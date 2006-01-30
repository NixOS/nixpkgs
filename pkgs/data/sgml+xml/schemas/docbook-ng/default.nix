{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-ng-5.0pre20050724-pto";
  builder = ./builder.sh;
  buildInputs = [unzip];

  rng = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook.rng;
    md5 = "508a56c9602e0321f64df4b5032f4a05";
  };

  rnc = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook.rnc;
    md5 = "046e583f912fb38c28035cbdec055fc7";
  };

  xirng = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbookxi.rng;
    md5 = "e377fb2d80d96f098e367003ad51a983";
  };

  xirnc = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbookxi.rnc;
    md5 = "e8a233600fc58a1eab04451f530d4455";
  };

  dtd = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook.dtd;
    md5 = "65f04909e0f9f64c18f0c5267d95bf70";
  };

  xidtd = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbookxi.dtd;
    md5 = "37168ed996c5271d818eb258f1509834";
  };
}
