{ stdenv, fetchurl, pkgconfig, yacc, flex, xkeyboard_config, libxcb }:

stdenv.mkDerivation (rec {
  name = "libxkbcommon-0.5.0";

  src = fetchurl {
    url = "http://xkbcommon.org/download/${name}.tar.xz";
    sha1 = "z9dvxrkcyb4b7f2zybgkrqb9zcxrj9vi";
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

// 

# --version-script as an argument to `ld` is not supported on OS X
stdenv.lib.optionalAttrs stdenv.isDarwin {
  preBuild =  ''
    sed -i 's/,--version-script=.*$//' Makefile
  '';
})
