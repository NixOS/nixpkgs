{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.4.2";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "0mw9ljc5fbqbhnm884w7ns5pf6f2rqj9ww5xcaps9nzdgsq73z50";
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
