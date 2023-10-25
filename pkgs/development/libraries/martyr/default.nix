{lib, stdenv, fetchurl, ant, jdk}:

stdenv.mkDerivation rec {
  pname = "martyr";
  version = "0.3.9";
  src = fetchurl {
    url = "mirror://sourceforge/martyr/${pname}-${version}.tar.gz";
    sha256 = "1ks8j413bcby345kmq1i7av8kwjvz5vxdn1zpv0p7ywxq54i4z59";
  };

  buildInputs = [ ant jdk ];

  buildPhase = "ant";

  installPhase = ''
    mkdir -p "$out/share/java"
    cp -v *.jar "$out/share/java"
  '';

  meta = {
    description = "Java framework around the IRC protocol to allow application writers easy manipulation of the protocol and client state";
    homepage = "https://martyr.sourceforge.net/";
    license = lib.licenses.lgpl21;
  };
}
