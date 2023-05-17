{ lib, stdenvNoCC, texlive }:

stdenvNoCC.mkDerivation {
  pname = "iwona";
  version = "0.995b";

  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.iwona.pkgs);

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/opentype/nowacki/iwona/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "https://jmn.pl/en/kurier-i-iwona/";
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
