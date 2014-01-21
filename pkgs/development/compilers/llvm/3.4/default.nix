{ newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.4";

  fetch = name: sha256: fetchurl {
    url = "http://llvm.org/releases/${version}/${name}-${version}.src.tar.gz";
    inherit sha256;
  };

  self = {
    llvm = callPackage ./llvm.nix {};

    clang = callPackage ./clang.nix {};

    lld = callPackage ./lld.nix {};

    lldb = callPackage ./lldb.nix {};

    polly = callPackage ./polly.nix {};

    dragonegg = callPackage ./dragonegg.nix {};
  };
in self
