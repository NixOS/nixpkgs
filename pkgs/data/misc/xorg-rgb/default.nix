{stdenv, fetchurl, pkgconfig, xproto}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "rgb";
  version = "1.0.6";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/rgb-${version}.tar.bz2";
    sha256 = "1c76zcjs39ljil6f6jpx1x17c8fnvwazz7zvl3vbjfcrlmm7rjmv";
  };

  nativeBuildInputs = [pkgconfig];
  buildInputs = [xproto];
  meta = {
    inherit version;
    description = "X11 colorname to RGB mapping database";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://xorg.freedesktop.org/;
  };
}
