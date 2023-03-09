{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "stix-two";
  version = "2.13";

  src = fetchzip {
    url = "https://github.com/stipub/stixfonts/raw/v${version}/zipfiles/STIX${builtins.replaceStrings [ "." ] [ "_" ] version}-all.zip";
    stripRoot = false;
    hash = "sha256-hfQmrw7HjlhQSA0rVTs84i3j3iMVR0k7tCRBcB6hEpU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*.otf -t $out/share/fonts/opentype
    install -Dm644 */*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
