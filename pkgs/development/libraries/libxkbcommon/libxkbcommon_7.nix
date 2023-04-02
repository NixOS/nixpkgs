{ lib, stdenv, fetchurl, pkg-config, bison, flex, xkeyboard_config, libxcb, libX11 }:

stdenv.mkDerivation rec {
  pname = "libxkbcommon";
  version = "0.7.2";

  src = fetchurl {
    url = "http://xkbcommon.org/download/libxkbcommon-${version}.tar.xz";
    sha256 = "1n5rv5n210kjnkyrvbh04gfwaa7zrmzy1393p8nyqfw66lkxr918";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ bison flex xkeyboard_config libxcb ];

  configureFlags = [
    "--with-xkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "--with-x-locale-root=${libX11.out}/share/X11/locale"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    sed -i 's/,--version-script=.*$//' Makefile
  '';

  meta = with lib; {
    description = "A library to handle keyboard descriptions";
    homepage = "https://xkbcommon.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ttuegel ];
    mainProgram = "xkbcli";
    platforms = with platforms; unix;
  };
}
