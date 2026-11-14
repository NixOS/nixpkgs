# Realigns ELF64 PT_LOAD segments so (p_vaddr - p_offset) % PAGE_SIZE == 0
# by inserting padding before misaligned segments. p_vaddr is never
# touched, so relocations stay correct.
#
# Fixes glibc's "ELF load command address/offset not page-aligned"
# (elf/dl-load.c): the check is against the runtime page size, not
# p_align, so a 4K-assuming binary fails on a larger-page-size kernel
# (Apple Silicon/Asahi: 16K; Android 15+: 16K on many devices). patchelf
# can't fix this -- it only aligns segments it adds itself.
import struct
import sys

PAGE_SIZE = 65536  # safe for 4K, 16K and 64K page kernels alike
PT_LOAD = 1


def fix(path):
    with open(path, "rb") as f:
        data = bytearray(f.read())

    if len(data) < 64 or data[:4] != b"\x7fELF" or data[4] != 2 or data[5] != 1:
        return False  # not ELF64 LE

    e_phoff, = struct.unpack_from("<Q", data, 0x20)
    e_shoff, = struct.unpack_from("<Q", data, 0x28)
    e_phentsize, e_phnum = struct.unpack_from("<HH", data, 0x36)
    e_shentsize, e_shnum = struct.unpack_from("<HH", data, 0x3A)

    if e_phoff == 0 or e_phnum == 0:
        return False

    phdrs = []
    for i in range(e_phnum):
        off = e_phoff + i * e_phentsize
        p_type, _flags, p_offset, p_vaddr, _paddr, p_filesz, _memsz, _align = (
            struct.unpack_from("<IIQQQQQQ", data, off)
        )
        phdrs.append({"hdr_off": off, "type": p_type, "offset": p_offset, "vaddr": p_vaddr, "filesz": p_filesz})

    # Single forward pass over PT_LOADs in offset order: each segment is
    # checked against where it will actually land once earlier insertions
    # have shifted it forward, not its pristine offset.
    insertions = []  # (original_offset, pad_len)
    cumulative = 0
    for ph in sorted((p for p in phdrs if p["type"] == PT_LOAD), key=lambda p: p["offset"]):
        effective_off = ph["offset"] + cumulative
        rem = (ph["vaddr"] - effective_off) % PAGE_SIZE
        if rem != 0:
            insertions.append((ph["offset"], rem))
            cumulative += rem

    if not insertions:
        return False

    # Insertion points must land exactly on a PT_LOAD boundary, never inside
    # one (other segment types like TLS/GNU_RELRO/DYNAMIC are views into a
    # LOAD's data and legitimately share its offset range).
    for off, _pad in insertions:
        for ph in phdrs:
            if ph["type"] == PT_LOAD and ph["offset"] < off < ph["offset"] + ph["filesz"]:
                raise ValueError(f"insertion point 0x{off:x} falls inside segment at 0x{ph['offset']:x}")

    # Apply highest-offset-first so earlier insertion points stay valid
    # indices into the still-growing bytearray.
    for off, pad in sorted(insertions, key=lambda t: -t[0]):
        data[off:off] = b"\x00" * pad

    def shift_for(orig_off):
        return sum(pad for off, pad in insertions if off <= orig_off)

    for ph in phdrs:
        new_hdr_off = ph["hdr_off"] + shift_for(ph["hdr_off"])
        new_p_offset = ph["offset"] + shift_for(ph["offset"])
        struct.pack_into("<Q", data, new_hdr_off + 8, new_p_offset)

    if e_shoff and e_shnum:
        for i in range(e_shnum):
            hdr_off = e_shoff + i * e_shentsize
            new_hdr_off = hdr_off + shift_for(hdr_off)
            sh_offset, = struct.unpack_from("<Q", data, new_hdr_off + 0x18)
            struct.pack_into("<Q", data, new_hdr_off + 0x18, sh_offset + shift_for(sh_offset))
        struct.pack_into("<Q", data, 0x28, e_shoff + shift_for(e_shoff))

    with open(path, "wb") as f:
        f.write(data)
    return True


if __name__ == "__main__":
    for p in sys.argv[1:]:
        try:
            if fix(p):
                print(f"elf-16k-align-fix: realigned {p}")
        except ValueError as e:
            print(f"elf-16k-align-fix: SKIP {p}: {e}", file=sys.stderr)
