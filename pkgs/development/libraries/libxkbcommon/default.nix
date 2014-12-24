{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.4.3";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha1 = "2251adc7425c816ec7af4f1c3776a619a53293b6";
  };

  buildInputs = [ pkgconfig yacc flex xkeyboard_config libxcb ];

  configureFlags = ''
    --with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb
  '';

  meta = {
    description = "A library to handle keyboard descriptions";
    homepage = http://xkbcommon.org;
  };
}
