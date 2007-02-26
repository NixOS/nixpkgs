{stdenv, fetchurl, freetype, expat}:

assert freetype != null && expat != null;

stdenv.mkDerivation {
  name = "fontconfig-2.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://fontconfig.org/release/fontconfig-2.4.2.tar.gz;
    sha256 = "0qqk6hqh8ardqlgzdgj0zjn6a61z4j6ba9x3xs8pp0c2650xd8v3";
  };
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks
}
