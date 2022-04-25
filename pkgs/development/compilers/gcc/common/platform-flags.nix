{ lib, targetPlatform }:

let
  p =  targetPlatform.gcc or {}
    // targetPlatform.parsed.abi;
in lib.concatLists [
  (lib.optional (!targetPlatform.isx86_64 && p ? arch) "--with-arch=${p.arch}") # --with-arch= is unknown flag on x86_64
  (lib.optional (p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (p ? float) "--with-float=${p.float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")
  (lib.optionals targetPlatform.isPower64
    # musl explicitly rejects 128-bit long double on
    # powerpc64; see musl/arch/powerpc64/bits/float.h
    (lib.optionals (!targetPlatform.isMusl) [
      "--with-long-double-128"
      "--with-long-double-format=ieee"
    ]))
]
