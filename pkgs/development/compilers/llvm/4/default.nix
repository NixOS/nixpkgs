{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv isl release_version version fetch; });

  release_version = "4.0.0";
  rc = "rc3";
  version = "${release_version}${rc}";

  fetch = name: sha256: fetchurl {
    url = "http://llvm.org/pre-releases/${release_version}/${rc}/${name}-${version}.src.tar.xz";
    # Once 4 is released, use this instead:
    # url = "http://llvm.org/releases/${release-version}/${name}-${version}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0jfqhz95cp15c5688c6l9mr12s0qp86milpcrjlc93dc2jy08ba5";
  clang-tools-extra_src = fetch "clang-tools-extra" "1c9c507w3f5vm153rdd0kmzvv2ski6z439izk01zf5snfwkqxkq8";

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
