{ newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.4";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.gz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "0p5b6varxdqn7q3n77xym63hhq4qqxd2981pfpa65r1w72qqjz7k";
  clang-tools-extra_src = fetch "clang-tools-extra" "1d1822mwxxl9agmyacqjw800kzz5x8xr0sdmi8fgx5xfa5sii1ds";

  self = {
    llvm = callPackage ./llvm.nix rec {
      version = "3.4.2";
      fetch = fetch_v version;
      inherit compiler-rt_src;
    };

    clang = callPackage ./clang.nix rec {
      version = "3.4.2";
      fetch = fetch_v version;
      inherit clang-tools-extra_src;
    };

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    polly = callPackage ./polly.nix {};

    dragonegg = callPackage ./dragonegg.nix {};
  };
in self
