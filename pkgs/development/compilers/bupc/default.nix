{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {

name = "berkeley_upc-2.22.0";

src = fetchurl {

url = "http://upc.lbl.gov/download/release/${name}.tar.gz";
sha256 = "041l215x8z1cvjcx7kwjdgiaf9rl2d778k6kiv8q09bc68nwd44m";

};

buildInputs = [perl];


}
