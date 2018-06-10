{ lowPrio, newScope, stdenv, targetPlatform, cmake, libstdcxxHook
, libxml2, python2, isl, fetchurl, overrideCC, wrapCCWith
, darwin
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  release_version = "4.0.1";
  version = release_version; # differentiating these is important for rc's

  fetch = name: sha256: fetchurl {
    url = "https://releases.llvm.org/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0h5lpv1z554szi4r4blbskhwrkd78ir50v3ng8xvk1s86fa7gj53";
  clang-tools-extra_src = fetch "clang-tools-extra" "1dhmp7ccfpr42bmvk3kp37ngjpf3a9m5d4kkpsn7d00hzi7fdl9m";

  # Add man output without introducing extra dependencies.
  overrideManOutput = drv:
    let drv-manpages = drv.override { enableManpages = true; }; in
    drv // { man = drv-manpages.out; /*outputs = drv.outputs ++ ["man"];*/ };

  tools = let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python2 isl release_version version fetch; });
  in {

    llvm = overrideManOutput (callPackage ./llvm.nix {
      inherit compiler-rt_src;
      inherit (targetLlvmLibraries) libcxxabi;
    });
    clang-unwrapped = overrideManOutput (callPackage ./clang {
      inherit clang-tools-extra_src;
    });

    libclang = tools.clang-unwrapped.lib;
    llvm-manpages = lowPrio tools.llvm.man;
    clang-manpages = lowPrio tools.clang-unwrapped.man;

    clang = if stdenv.cc.isGNU then tools.libstdcxxClang else tools.libcxxClang;

    libstdcxxClang = wrapCCWith {
      cc = tools.clang-unwrapped;
      extraPackages = [ libstdcxxHook ];
    };

    libcxxClang = wrapCCWith {
      cc = tools.clang-unwrapped;
      extraPackages = [ targetLlvmLibraries.libcxx targetLlvmLibraries.libcxxabi ];
    };

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};
  };

  libraries = let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python2 isl release_version version fetch; });
  in {

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};

    openmp = callPackage ./openmp.nix {};
  };

in { inherit tools libraries; } // libraries // tools
