{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.6.1";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "0q47xa1szlxwgvwmhv4b7xwawnykz1hnc431d84nj8dlh2q8f22v";
  };

  outputs = [ "dev" "out" ];

  buildInputs = [ pkgconfig yacc flex xkeyboard_config libxcb ];

  configureFlags = ''
    --with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb
  '';

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/,--version-script=.*$//' Makefile
  '';

  meta = with stdenv.lib; {
    description = "A library to handle keyboard descriptions";
    homepage = http://xkbcommon.org;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
