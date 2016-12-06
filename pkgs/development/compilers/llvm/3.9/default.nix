{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC, darwin, ccWrapperFun }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.9.0";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${version}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "16m5g0hf8yg9npnw25j2a86g34nsvk9rsm3c84gbch2prm7j5rg0";
  clang-tools-extra_src = fetch "clang-tools-extra" "052zg0h5vbmxnh2ikc743rw3649f112dfyn8hg39x6cfxi3fqyjv";
  polly_src = fetch "polly" "0znrikgdaqq4g3b5bl3l4nngx11wah5ibkwp8pcam6q9218d43gg";
  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src polly_src stdenv;
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

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
