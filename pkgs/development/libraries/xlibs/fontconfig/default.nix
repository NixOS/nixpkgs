{stdenv, fetchurl, freetype, expat}:

assert freetype != null && expat != null;

stdenv.mkDerivation {
  name = "fontconfig-2.2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~fontconfig/release/fontconfig-2.2.3.tar.gz;
    md5 = "2466a797d645cda5eb466080fdaec416";
  };
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks
}
