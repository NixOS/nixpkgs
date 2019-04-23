{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb, libX11 }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.7.2";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "1n5rv5n210kjnkyrvbh04gfwaa7zrmzy1393p8nyqfw66lkxr918";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ yacc flex xkeyboard_config libxcb ];

  configureFlags = [
    "--with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "--with-x-locale-root=${libX11.out}/share/X11/locale"
  ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/,--version-script=.*$//' Makefile
  '';

  meta = with stdenv.lib; {
    description = "A library to handle keyboard descriptions";
    homepage = https://xkbcommon.org;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ttuegel ];
    platforms = with platforms; unix;
  };
}
