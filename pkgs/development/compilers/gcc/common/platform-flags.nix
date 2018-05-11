{ lib, targetPlatform }:

let
  p = targetPlatform.platform.gcc or {};
  float = p.float or (targetPlatform.parsed.abi.float or null);
in lib.concatLists [
  (lib.optional (p ? arch) "--with-arch=${p.arch}")
  (lib.optional (p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (float != null) "--with-float=${float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")
]
