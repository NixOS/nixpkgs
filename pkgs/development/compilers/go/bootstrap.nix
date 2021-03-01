{ stdenv, srcOnly, fetchurl, callPackage, Security }:

let
go_bootstrap = if stdenv.isAarch64 then
  srcOnly {
    name = "go-1.8-linux-arm64-bootstrap";
    src = fetchurl {
      url = "https://cache.xor.us/go-1.8-linux-arm64-bootstrap.tar.xz";
      sha256 = "0sk6g03x9gbxk2k1djnrgy8rzw1zc5f6ssw0hbxk6kjr85lpmld6";
    };
  }
else
  callPackage ./1.4.nix {
    inherit Security;
  };
in
  go_bootstrap
