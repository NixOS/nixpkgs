{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fraunces";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/undercasetype/Fraunces/releases/download/${version}/UnderCaseType_Fraunces_${version}.zip";
    hash = "sha256-hu2G4Fs2I3TMEy/EBFnc88Pv3c8Mpc5rm3OwVvol7gQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */static/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 */static/ttf/*.ttf */*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A display, “Old Style” soft-serif typeface inspired by early 20th century typefaces";
    homepage = "https://github.com/undercasetype/Fraunces";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
