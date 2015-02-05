{ pkgs, newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.5.0";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0dl1kbrhz96djsxqr61iw5h788s7ncfpfb7aayixky1bhdaydcx4";
  clang-tools-extra_src = fetch "clang-tools-extra" "0s8zjgxg8bj15nnqcw1cj1zffcralhh7f0gda1famddgg2rvx099";

  self = {
    llvm = callPackage ./llvm.nix rec {
      version = "3.5.0";
      fetch = fetch_v version;
      inherit compiler-rt_src;
    };

    clang = callPackage ./clang.nix rec {
      version = "3.5.0";
      fetch = fetch_v version;
      inherit clang-tools-extra_src;
    };

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    polly = callPackage ./polly.nix {};

    dragonegg = callPackage ./dragonegg.nix {};

    libcxx = callPackage ./libc++ { stdenv = pkgs.clangStdenv; };

    libcxxabi = callPackage ./libc++abi { stdenv = pkgs.clangStdenv; };
  };
in self
