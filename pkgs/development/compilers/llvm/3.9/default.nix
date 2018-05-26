{ newScope, stdenv, libstdcxxHook, isl, fetchurl, overrideCC, wrapCCWith, darwin
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  version = "3.9.1";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${version}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "16gc2gdmp5c800qvydrdhsp0bzb97s8wrakl6i8a4lgslnqnf2fk";
  clang-tools-extra_src = fetch "clang-tools-extra" "0d9nh7j7brbh9avigcn69dlaihsl9p3cf9s45mw6fxzzvrdvd999";

  tools = let
    callPackage = newScope (tools // { inherit stdenv isl version fetch; });
  in {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src;
      inherit (targetLlvmLibraries) libcxxabi;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src;
    };

    libclang = tools.clang-unwrapped.lib;

    clang = if stdenv.cc.isGNU then tools.libstdcxxClang else tools.libcxxClang;

    libstdcxxClang = wrapCCWith {
      cc = tools.clang-unwrapped;
      extraPackages = [ libstdcxxHook ];
    };

    libcxxClang = wrapCCWith {
      cc = tools.clang-unwrapped;
      extraPackages = [ targetLlvmLibraries.libcxx targetLlvmLibraries.libcxxabi ];
    };

    lldb = callPackage ./lldb.nix {};
  };

  libraries = let
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv isl version fetch; });
  in {

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };

in { inherit tools libraries; } // libraries // tools
