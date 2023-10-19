{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-wenkai";
  version = "1.311";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-R7j6SBWGbkS4cJI1J8M5NDIDeJDFMjtXZnGiyxm2rjg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://lxgw.github.io/";
    description = "An open-source Chinese font derived from Fontworks' Klee One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ elliot ];
  };
}
