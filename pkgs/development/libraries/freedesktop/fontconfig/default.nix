{stdenv, fetchurl, freetype, expat}:

assert freetype != null && expat != null;

stdenv.mkDerivation {
  name = "fontconfig-2.2.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~fontconfig/release/fontconfig-2.2.2.tar.gz;
    md5 = "af6e9a8addfa89aa68d703d5eb004185";
  };
  buildInputs = [freetype];
  propagatedBuildInputs = [expat]; # !!! shouldn't be necessary, but otherwise pango breaks
}
