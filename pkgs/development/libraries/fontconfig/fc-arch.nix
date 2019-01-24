{ platform }:

## commit 1845f3100d15927cc536bc3d38f140c139fb5614
## Author: Behdad Esfahbod <behdad@behdad.org>
## Date:   Wed Nov 18 14:39:34 2009 -0500
## 
##     [fc-arch] Rename architecture names to better reflect what they are
## 
##     We only care about three properties in the arch:
## 
##       - endianness
##       - pointer size
##       - for 32-bit archs, whether double is aligned on 4 or 8 bytes
## 
##     This leads to the following 6 archs (old name -> new name):
## 
##             x86    -> le32d4
##             mipsel -> le32d8
##             x86-64 -> le64
##             m68k   -> be32d4
##             ppc    -> be32d8
##             ppc64  -> be64


# TODO: Handle double alignment

let
  cpu = platform.parsed.cpu;
  endian = {
    littleEndian = "le";
    bigEndian = "be";
  }."${cpu.significantByte.name}" or (throw "unhandled endianness");
  FC_ARCHITECTURE = endian + (toString cpu.bits);

in
  FC_ARCHITECTURE
