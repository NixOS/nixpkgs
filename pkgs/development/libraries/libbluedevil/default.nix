{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libbluedevil";
  version = "1.9.3";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0fdq083145mb3ynw14pc471ahp7is48wqpmswrvfz3hkyayriss3";
  };

  buildInputs = [ cmake qt4 ];
}
