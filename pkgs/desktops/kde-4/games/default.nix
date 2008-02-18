args: with args;

stdenv.mkDerivation rec {
  name = "kdegames-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "11am026l68dm3v8mxa1phsizsy73c999493dkqc2kpff2kvhbxvs";
  };

  propagatedBuildInputs = [kde4.pimlibs];
  buildInputs = [cmake];
}
