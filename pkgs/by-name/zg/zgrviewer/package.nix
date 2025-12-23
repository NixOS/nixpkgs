{
  lib,
  stdenv,
  fetchurl,
  jre,
  unzip,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zgrviewer";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/zvtm/zgrviewer/${finalAttrs.version}/zgrviewer-${finalAttrs.version}.zip";
    hash = "sha256-0CrioPNtpUa8uCZOXpe2q/QOo90kYO7mC2s9x3ymP7I=";
  };

  nativeBuildInputs = [ unzip ];

  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/java/zvtm/plugins,share/doc/zvtm}
    cp *.license.* "$out/share/doc/zvtm"
    cp -r target/* "$out/share/java/zvtm/"
    echo '#!${runtimeShell}' > "$out/bin/zgrviewer"
    echo "${lib.getExe jre} -jar '$out/share/java/zvtm/zgrviewer-${finalAttrs.version}.jar' \"\$@\"" >> "$out/bin/zgrviewer"
    chmod a+x "$out/bin/zgrviewer"

    runHook postInstall
  '';

  meta = {
    # Quicker to unpack locally than load Hydra
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ raskin ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl21Plus;
    description = "GraphViz graph viewer/navigator";
    platforms = with lib.platforms; unix;
    mainProgram = "zgrviewer";
  };
})
