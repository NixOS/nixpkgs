{
  lib,
  stdenv,
  zig,
  callPackage,
  wrapCCWith,
  wrapBintoolsWith,
  overrideCC,
  targetPackages,
}:
{
  hook = callPackage ./hook.nix { inherit zig; };

  bintools-unwrapped = callPackage ./bintools.nix { inherit zig; };
  bintools = wrapBintoolsWith { bintools = zig.bintools-unwrapped; };

  cc-unwrapped = callPackage ./cc.nix { inherit zig; };
  cc = wrapCCWith {
    cc = zig.cc-unwrapped;
    bintools = zig.bintools;
    extraPackages = [ ];
    nixSupport.cc-cflags = [
      "-target"
      "${stdenv.targetPlatform.system}-${stdenv.targetPlatform.parsed.abi.name}"
    ];
  };

  stdenv = overrideCC stdenv zig.cc;

  fetchDeps = callPackage ./fetcher.nix { inherit zig; };
}
