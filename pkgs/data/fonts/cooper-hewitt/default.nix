{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cooper-hewitt";
  version = "unstable-2014-06-09";

  src = fetchzip {
    url = "https://web.archive.org/web/20221004145117/https://www.cooperhewitt.org/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip";
    hash = "sha256-bTlEXQeYNNspvnNdvQhJn6CNBrcSKYWuNWF/N6+3Vb0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mv *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.cooperhewitt.org/open-source-at-cooper-hewitt/cooper-hewitt-the-typeface-by-chester-jenkins/";
    description = "Contemporary sans serif, with characters composed of modified-geometric curves and arches";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
