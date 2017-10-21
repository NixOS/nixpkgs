{stdenv, fetchurl, ant, jdk}:

stdenv.mkDerivation rec {
	name = "martyr-${version}";
  version = "0.3.9";
	src = fetchurl {
		url = "mirror://sourceforge/martyr/${name}.tar.gz";
		sha256 = "1ks8j413bcby345kmq1i7av8kwjvz5vxdn1zpv0p7ywxq54i4z59";
	};

  buildInputs = [ ant jdk ];

  buildPhase = "ant";

  installPhase = ''
    mkdir -p "$out/share/java"
    cp -v *.jar "$out/share/java"
  '';

  meta = {
    description = "Martyr is a Java framework around the IRC protocol to allow application writers easy manipulation of the protocol and client state";
    homepage = http://martyr.sourceforge.net/;
  };
}
