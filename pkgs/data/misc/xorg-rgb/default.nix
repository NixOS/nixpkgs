{lib, stdenv, fetchurl, pkg-config, xorgproto}:
stdenv.mkDerivation rec {
  pname = "rgb";
  version = "1.0.6";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/rgb-${version}.tar.bz2";
    sha256 = "1c76zcjs39ljil6f6jpx1x17c8fnvwazz7zvl3vbjfcrlmm7rjmv";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [xorgproto];
  meta = {
    description = "X11 colorname to RGB mapping database";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "http://xorg.freedesktop.org/";
  };
}
