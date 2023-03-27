{ lib, stdenvNoCC, fetchzip, texlive }:

stdenvNoCC.mkDerivation rec {
  pname = "newcomputermodern";
  inherit (src) version;

  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.newcomputermodern.pkgs);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/otf
    mv fonts/opentype/public/newcomputermodern/*.otf $out/share/fonts/otf/

    runHook postInstall
  '';

  meta = {
    description = "Computer Modern fonts including matching non-latin alphabets";
    homepage = "https://ctan.org/pkg/newcomputermodern";
    # "The GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = lib.licenses.lppl13c;
    maintainers = [ lib.maintainers.drupol ];
    platforms = lib.platforms.all;
  };
}
