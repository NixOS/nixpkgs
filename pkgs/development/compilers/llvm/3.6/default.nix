{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.6.2";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "11qx8d3pbfqjaj2x207pvlvzihbs1z2xbw4crpz7aid6h1yz6bqg";
  clang-tools-extra_src = fetch "clang-tools-extra" "1ssgs1108gnsggyx9wcl4hmq196f5ix0y1j7ygfh3xcqsckwc3ka";

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
