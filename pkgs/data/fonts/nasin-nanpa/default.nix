{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa";
  version = "2.5.1";

  srcs = [
    (fetchurl {
      name = "nasin-nanpa.otf";
      url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}.otf";
      hash = "sha256-++uOrqFzQ6CB/OPEmBivpjMfAtFk3PSsCNpFBjOtGEg=";
    })
    (fetchurl {
      name = "nasin-nanpa-lasina-kin.otf";
      url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}-lasina-kin.otf";
      hash = "sha256-4WIX74y2O4NaKi/JQrgTbOxlKDQKJ/F9wkQuoOdWuTI=";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    for src in $srcs; do
        file=$(stripHash $src)
        cp $src $out/share/fonts/opentype/$file
    done
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
