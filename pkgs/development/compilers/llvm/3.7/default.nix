{ newScope, stdenv, libstdcxxHook, cmake, libxml2, python2, isl, fetchurl
, overrideCC, wrapCC, ccWrapperFun, darwin
}:

let
  callPackage = newScope (self // { inherit stdenv cmake libxml2 python2 isl version fetch; });

  version = "3.7.1";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "10c1mz2q4bdq9bqfgr3dirc6hz1h3sq8573srd5q5lr7m7j6jiwx";
  clang-tools-extra_src = fetch "clang-tools-extra" "0sxw2l3q5msbrwxv1ck72arggdw6n5ysi929gi69ikniranfv4aa";

  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src stdenv;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src stdenv;
    };

    clang = if stdenv.cc.isGNU then self.libstdcxxClang else self.libcxxClang;

    libstdcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      /* FIXME is this right? */
      inherit (stdenv.cc) bintools libc nativeTools nativeLibc;
      extraPackages = [ libstdcxxHook ];
    };

    libcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      /* FIXME is this right? */
      inherit (stdenv.cc) bintools libc nativeTools nativeLibc;
      extraPackages = [ self.libcxx self.libcxxabi ];
    };

    stdenv = stdenv.override (drv: {
      allowedRequisites = null;
      cc = self.clang;
    });

    libcxxStdenv = stdenv.override (drv: {
      allowedRequisites = null;
      cc = self.libcxxClang;
    });

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
