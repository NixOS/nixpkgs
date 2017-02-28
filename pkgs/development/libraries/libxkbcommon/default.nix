{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb, libX11 }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.7.1";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "ba59305d2e19e47c27ea065c2e0df96ebac6a3c6e97e28ae5620073b6084e68b";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ pkgconfig yacc flex xkeyboard_config libxcb ];

  configureFlags = [
    "--with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "--with-x-locale-root=${libX11.out}/share/X11/locale"
  ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/,--version-script=.*$//' Makefile
  '';

  meta = with stdenv.lib; {
    description = "A library to handle keyboard descriptions";
    homepage = http://xkbcommon.org;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = with platforms; unix;
  };
}
