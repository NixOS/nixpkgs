{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ibm-plex";
  version = "6.4.0";

  src = fetchzip {
    url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";
    hash = "sha256-/aR3bu03VxenSPed6EqrGoPjWCcKT//MVtb9OC8tSRs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*.otf IBM-Plex-Sans-JP/unhinted/* -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    changelog = "https://github.com/IBM/plex/raw/v${version}/CHANGELOG.md";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
