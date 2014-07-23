{ newScope, stdenv, isl, fetchurl }:
let
  callPackage = newScope (self // { inherit stdenv isl version fetch; });

  version = "3.4";

  fetch = fetch_v version;
  fetch_v = ver: name: sha256: fetchurl {
    url = "http://llvm.org/releases/${ver}/${name}-${ver}.src.tar.gz";
    inherit sha256;
  };

  compiler-rt_src = fetch "compiler-rt" "f37c89b1383ce462d47537a0245ac798600887a9be9f63073e16b79ed536ab5c";
  clang-tools-extra_src = fetch "clang-tools-extra" "ba85187551ae97fe1c8ab569903beae5ff0900e21233e5eb5389f6ceab1028b4";

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
