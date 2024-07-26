{ callPackage, fetchurl }:

callPackage ./generic.nix ( rec {
  version = "0.9.74";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "sha256-QgNdAmE3MyS/tDQBj0q4klFLECU9GvIy5BtMwsEeZQs=";
  };
})
