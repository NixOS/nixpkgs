{ lib, stdenv, fetchurl, pkg-config, xorgproto }:

stdenv.mkDerivation rec {
  pname = "rgb";
  version = "1.0.6";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/rgb-${version}.tar.bz2";
    sha256 = "1c76zcjs39ljil6f6jpx1x17c8fnvwazz7zvl3vbjfcrlmm7rjmv";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  meta = with lib; {
    description = "X11 colorname to RGB mapping database";
    license = licenses.mit;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    homepage = "https://xorg.freedesktop.org/";
  };
}
