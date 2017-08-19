{ newScope, stdenv, cmake, libxml2, python2, isl, fetchurl, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv cmake libxml2 python2 isl release_version version fetch; });

  release_version = "5.0.0";
  version = "5.0.0rc2"; # differentiating these is important for rc's

  fetch = name: sha256: fetchurl {
    url = "http://prereleases.llvm.org/${release_version}/rc2/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "07ip30f6scx59zy2jch7gqjp0amb9gy1wci87x6fxdf55i4l8rb4";
  clang-tools-extra_src = fetch "clang-tools-extra" "1298jk0nn5pizac2d775164y3yklc2hm0rgzxmg771rk0fcfnggr";

  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src stdenv;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src stdenv;
    };

    clang = wrapCC self.clang-unwrapped;

    libcxxClang = ccWrapperFun {
      cc = self.clang-unwrapped;
      isClang = true;
      inherit (self) stdenv;
      /* FIXME is this right? */
      inherit (stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ self.libcxx self.libcxxabi ];
    };

    stdenv = overrideCC stdenv self.clang;

    libcxxStdenv = overrideCC stdenv self.libcxxClang;

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
