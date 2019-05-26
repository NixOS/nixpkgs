{ lib, targetPlatform }:

let
  p =  targetPlatform.platform.gcc or {}
    // targetPlatform.parsed.abi;
in lib.concatLists [
  (lib.optional (!targetPlatform.isx86_64 && p ? arch) "--with-arch=${p.arch}") # --with-arch= is unknown flag on x86_64
  (lib.optional (p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (p ? float) "--with-float=${p.float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")
  (lib.optional
    (let tp = targetPlatform; in tp.isPower && tp.libc == "glibc" && tp.is64bit && tp.isLittleEndian)
    "--with-long-double-128")
]
