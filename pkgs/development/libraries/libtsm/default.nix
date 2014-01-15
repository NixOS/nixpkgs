{ stdenv, fetchurl, libxkbcommon, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libtsm-3";

  src = fetchurl {
    url = "http://freedesktop.org/software/kmscon/releases/${name}.tar.xz";
    sha256 = "01ygwrsxfii0pngfikgqsb4fxp8n1bbs47l7hck81h9b9bc1ah8i";
  };

  buildInputs = [ libxkbcommon pkgconfig ];

  configureFlags = [ "--disable-debug" ];

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
