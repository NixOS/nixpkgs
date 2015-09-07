{ pkgs, newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.5.2";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.xz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "1hsdnzzdr5kglz6fnv3lcsjs222zjsy14y8ax9dy6zqysanplbal";
  clang-tools-extra_src = fetch "clang-tools-extra" "01607w6hdf1pjgaapn9fy6smk22i3d4ncqjlhk4xi55ifi6kf6pj";

  self = {
    llvm = callPackage ./llvm.nix rec {
      version = "3.5.2";
      fetch = fetch_v version;
      inherit compiler-rt_src;
    };

    clang = callPackage ./clang.nix rec {
      version = "3.5.2";
      fetch = fetch_v version;
      inherit clang-tools-extra_src;
    };

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    polly = callPackage ./polly.nix {};

    dragonegg = callPackage ./dragonegg.nix {};

    libcxx = callPackage ./libc++ { stdenv = pkgs.clangStdenv; };

    libcxxabi = callPackage ./libc++abi { stdenv = pkgs.clangStdenv; };

    #openmp = callPackage ./openmp {};
  };
in self
