{ lowPrio, newScope, stdenv, targetPlatform, cmake, libstdcxxHook
, libxml2, python2, isl, fetchurl, overrideCC, wrapCC, ccWrapperFun
, darwin
}:

let
  callPackage = newScope (self // { inherit stdenv cmake libxml2 python2 isl release_version version fetch; });

  release_version = "5.0.0";
  version = release_version; # differentiating these is important for rc's

  fetch = name: sha256: fetchurl {
    url = "http://llvm.org/releases/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "1cy0y389zxn7mk8vffqvfirk9bbcbc8ziwc1nf1a8d118rk55bfm";
  clang-tools-extra_src = fetch "clang-tools-extra" "1ikkv6k8cfgpjqlm24iqz52i5nyafzsc4dyikzzyb9n4b6wpil47";

  # Add man output without introducing extra dependencies.
  overrideManOutput = drv:
    let drv-manpages = drv.override { enableManpages = true; }; in
    drv // { man = drv-manpages.man; /*outputs = drv.outputs ++ ["man"];*/ };

  llvm = callPackage ./llvm.nix {
    inherit compiler-rt_src stdenv;
  };

  clang-unwrapped = callPackage ./clang {
    inherit clang-tools-extra_src stdenv;
  };

  self = {
    llvm = overrideManOutput llvm;
    clang-unwrapped = overrideManOutput clang-unwrapped;

    llvm-manpages = lowPrio self.llvm.man;
    clang-manpages = lowPrio self.clang-unwrapped.man;

    clang = if stdenv.cc.isGNU then self.libstdcxxClang else self.libcxxClang;

    libstdcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ libstdcxxHook ];
    };

    libcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ self.libcxx self.libcxxabi ];
    };

    stdenv = stdenv.override (drv: {
      allowedRequisites = null;
      cc = self.clang;
      # Don't include the libc++ and libc++abi from the original stdenv.
      extraBuildInputs = stdenv.lib.optional stdenv.isDarwin darwin.CF;
    });

    libcxxStdenv = stdenv.override (drv: {
      allowedRequisites = null;
      cc = self.libcxxClang;
      # Don't include the libc++ and libc++abi from the original stdenv.
      extraBuildInputs = stdenv.lib.optional stdenv.isDarwin darwin.CF;
    });

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};

    openmp = callPackage ./openmp.nix {};
  };

in self
