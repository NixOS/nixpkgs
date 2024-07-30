{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}.otf";
    hash = "sha256-remTvvOt7kpvTdq9H8tFI2yU+BtqePXlDDLQv/jtETU=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp $src $out/share/fonts/opentype/nasin-nanpa.otf
  '';

  meta = with lib; {
    homepage = "https://github.com/ETBCOR/nasin-nanpa";
    description = "UCSUR OpenType monospaced font for the Toki Pona writing system, Sitelen Pona";
    longDescription = ''
      ni li nasin pi sitelen pona.
      sitelen ale pi nasin ni li sama mute weka.
      sitelen pi nasin ni li lon nasin UCSUR kin.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
