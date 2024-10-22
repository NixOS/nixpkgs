{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "stix-otf";
  version = "1.1.1";

  src = fetchzip {
    url = "https://sources.debian.org/src/fonts-stix/1.1.1-4.1/STIXv${version}-word.zip";
    stripRoot = false;
    hash = "sha256-M3STue+RPHi8JgZZupV0dVLZYKBiFutbBOlanuKkD08=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 Fonts/STIX-Word/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
