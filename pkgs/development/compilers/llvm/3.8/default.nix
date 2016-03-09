{ newScope, stdenv, isl, fetchurl, overrideCC, wrapCC }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.8.0";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "1c2nkp9563873ffz22qmhc0wakgj428pch8rmhym8agjamz3ily8";
  clang-tools-extra_src = fetch "clang-tools-extra" "1i0yrgj8qrzjjswraz0i55lg92ljpqhvjr619d268vka208aigdg";

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
