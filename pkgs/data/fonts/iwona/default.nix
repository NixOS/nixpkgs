{ lib, stdenvNoCC, texlive }:

let src = texlive.iwona; in
stdenvNoCC.mkDerivation {
  inherit (src) pname version;
  inherit src;

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/opentype/nowacki/iwona/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "https://jmn.pl/en/kurier-i-iwona/";
    inherit (src.meta) license;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
