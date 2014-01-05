{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.3.1";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "13mk335r4dhi9qglzbp46ina1wz4qgcp8r7s06iq7j50pf0kb5ww";
  };

  buildInputs = [ pkgconfig yacc flex xkeyboard_config ];

  configureFlags = ''
    --with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb
  '';

  meta = {
    description = "A library to handle keyboard descriptions";
    homepage = http://xkbcommon.org;
  };
}
