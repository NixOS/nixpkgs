{ lib, targetPlatform }:

let
  isAarch64Darwin = targetPlatform.isDarwin && targetPlatform.isAarch64;
  gcc = targetPlatform.gcc or { };
  p = gcc // targetPlatform.parsed.abi;
in
lib.concatLists [
  # --with-arch= is unknown flag on x86_64 and aarch64-darwin.
  (lib.optional (!targetPlatform.isx86_64 && !isAarch64Darwin && p ? arch) "--with-arch=${p.arch}")
  # --with-cpu on aarch64-darwin fails with "Unknown cpu used in --with-cpu=apple-a13".
  (lib.optional (!isAarch64Darwin && p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (p ? float) "--with-float=${p.float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")
  (lib.optionals targetPlatform.isPower64
    # musl explicitly rejects 128-bit long double on
    # powerpc64; see musl/arch/powerpc64/bits/float.h
    (
      lib.optionals
        (
          !targetPlatform.isMusl
          && (
            targetPlatform.isLittleEndian
            ||
              # "... --with-long-double-format is only supported if the default cpu is power7 or newer"
              #  https://github.com/NixOS/nixpkgs/pull/170215#issuecomment-1202164709
              (lib.lists.elem (lib.strings.substring 0 6 (p.cpu or "")) [
                "power7"
                "power8"
                "power9"
                "power1" # 0, 11, etc
              ])
          )
        )
        [
          "--with-long-double-128"
          "--with-long-double-format=${gcc.long-double-format or "ieee"}"
        ]
    )
  )
  (lib.optional targetPlatform.isMips64n32 "--disable-libsanitizer") # libsanitizer does not compile on mips64n32
]
