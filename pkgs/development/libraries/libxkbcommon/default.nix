{ stdenv, fetchurl, yacc, flex, xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.2.0";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.bz2";
    sha256 = "0hpvfa8p4bhvhc1gcb578m354p5idd192xb8zlaq16d33h90msvl";
  };

  buildInputs = [ yacc flex xkeyboard_config ];

  configureFlags = ''
    --with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb
  '';

  meta = {
    description = "A library to handle keyboard descriptions";
    homepage = http://xkbcommon.org;
  };
}
