{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.9.0rc3";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/pre-releases/3.9.0/rc3/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "00ljgkjcds0z2z96zv02x39wryj902q29i895xixg60hd0909qra";
  clang-tools-extra_src = fetch "clang-tools-extra" "1nvc5f8g93hb76vrfygz2yafqa6kncpqwip7q1xwbw5fnw7rib5d";

  self = {
    llvm = callPackage ./llvm.nix {
      inherit compiler-rt_src stdenv;
    };

    clang-unwrapped = callPackage ./clang {
      inherit clang-tools-extra_src stdenv;
    };

    clang = wrapCC self.clang-unwrapped;

    stdenv = overrideCC stdenv self.clang;

    lldb = callPackage ./lldb.nix {};

    libcxx = callPackage ./libc++ {};

    libcxxabi = callPackage ./libc++abi.nix {};
  };
in self
