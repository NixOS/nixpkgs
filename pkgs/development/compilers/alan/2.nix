{ stdenv, lib, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "alan2";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "alan-if";
    repo = "alan";
    rev = "71f23ec79f7f5d66aa5ae9fd3f9b8dae41a89f15";
    sha256 = "066jknqz1v6sismvfxjfffl35h14v8qwgcq99ibhp08dy2fwraln";
  };

  makefile = "Makefile.unix";

  # Add a workarounf for -fno-common tollchains like upstream gcc-10.
  # alan-3 is already fixed, but the backport is nontrivial.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installPhase = ''
    mkdir -p $out/bin $out/share/alan2
    cp compiler/alan $out/bin/alan2
    cp interpreter/arun $out/bin/arun2
    cp alan.readme ChangeLog $out/share/alan2
  '';

  meta = with lib; {
    homepage = "https://www.alanif.se/";
    description = "The Alan interactive fiction language (legacy version)";
    license = licenses.artistic2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ neilmayhew ];
  };
}
