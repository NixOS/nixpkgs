{ newScope, stdenv, libstdcxxHook, isl, fetchurl, overrideCC, wrapCCWith, darwin
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
}:

let
  version = "3.8.1";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0p0y85c7izndbpg2l816z7z7558axq11d5pwkm4h11sdw7d13w0d";
  clang-tools-extra_src = fetch "clang-tools-extra" "15n39r4ssphpaq4a0wzyjm7ilwxb0bch6nrapy8c5s8d49h5qjk6";

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
