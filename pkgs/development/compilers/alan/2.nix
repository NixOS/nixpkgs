{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "alan2";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "alan-if";
    repo = "alan";
    rev = "71f23ec79f7f5d66aa5ae9fd3f9b8dae41a89f15";
    sha256 = "066jknqz1v6sismvfxjfffl35h14v8qwgcq99ibhp08dy2fwraln";
  };

  makefile = "Makefile.unix";

  env.NIX_CFLAGS_COMPILE = toString [
    # Add a workaround for -fno-common toolchains like upstream gcc-10.
    # alan-3 is already fixed, but the backport is nontrivial.
    "-fcommon"
    # smScSema.c:142:11: error: assignment to 'unsigned char *' from incompatible pointer type 'unsigned char **' [-Wincompatible-pointer-types]
    "-Wno-error=incompatible-pointer-types"
    # smScSema.c:183:10: error: implicit declaration of function 'read'; did you mean 'fread'? [-Wimplicit-function-declaration]
    "-Wno-error=implicit-function-declaration"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/alan2
    cp compiler/alan $out/bin/alan2
    cp interpreter/arun $out/bin/arun2
    cp alan.readme ChangeLog $out/share/alan2
  '';

  meta = with lib; {
    homepage = "https://www.alanif.se/";
    description = "Alan interactive fiction language (legacy version)";
    license = licenses.artistic2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ neilmayhew ];
  };
}
