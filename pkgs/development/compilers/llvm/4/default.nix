{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv isl release_version version fetch; });

  release_version = "4.0.0";
  version = release_version; # differentiating these is important for rc's

  fetch = name: sha256: fetchurl {
    url = "http://llvm.org/releases/${release_version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "059ipqq27gd928ay06f1ck3vw6y5h5z4zd766x8k0k7jpqimpwnk";
  clang-tools-extra_src = fetch "clang-tools-extra" "16bwckgcxfn56mbqjlxi7fxja0zm9hjfa6s3ncm3dz98n5zd7ds1";

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
