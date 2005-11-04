{stdenv, fetchurl, freetype, expat}:

assert freetype != null && expat != null;

stdenv.mkDerivation {
  name = "fontconfig-2.3.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.fontconfig.org/release/fontconfig-2.3.2.tar.gz;
    md5 = "7354f9f125ea78a8f2851cb9c31d4866";
  };
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks
}
