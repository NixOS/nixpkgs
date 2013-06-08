{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
	name = "muparser-2.2.2";
	src = fetchurl {
		url = mirror://sourceforge/muparser/muparser_v2_2_2.zip;
		sha256 = "0pncvjzzbwcadgpwnq5r7sl9v5r2y9gjgfnlw0mrs9wj206dbhx9";
	};

  buildInputs = [ unzip ];

  meta = {
    homepage = http://muparser.sourceforge.net;
    description = "An extensible high performance math expression parser library written in C++";
    license = "MIT";
  };
}
