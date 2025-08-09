{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unifont-csur";
  version = "16.0.03";

  src = fetchurl {
    url = "https://unifoundry.com/pub/unifont/unifont-${finalAttrs.version}/font-builds/unifont_csur-${finalAttrs.version}.otf";
    hash = "sha256-41MXxHHohZFm42LMePmLSZp3bytsxMJmWh/0psIgWt4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/unifont_csur.ttf
    runHook postInstall
  '';

  meta = {
    description = "Unifont CSUR - Private Use Area font covering ConScript Unicode Registry";
    homepage = "https://unifoundry.com/unifont/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.qxrein ];
  };
})
