{
  lib,
  stdenvNoCC,
  dockerTools,
  makeBinaryWrapper,
  jdk21_headless,
  gawk,
  statePath ? "/var/lib/youtrack",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "youtrack";
  version = "2025.3.116116";

  src = dockerTools.exportImage {
    diskSize = 8192;
    fromImage = dockerTools.pullImage {
      imageName = "jetbrains/youtrack";
      imageDigest = "sha256:7275406e0cad57699e400e050bc8325e872a5a1cdc1b2c8eeb3b94d73533c3fd";
      hash = "sha256-ZxY5PNRght+KEaVxqBHBgdMwRJTjBQLbY0s7yDZyUb4=";
    };
  };
  unpackPhase = ''
    mkdir source
    tar -C source -xvf $src ./opt/youtrack
    cd source
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r opt/youtrack/* $out
    makeWrapper $out/bin/youtrack.sh $out/bin/youtrack \
      --prefix PATH : "${lib.makeBinPath [ gawk ]}" \
      --set JRE_HOME ${jdk21_headless}
    rm -rf $out/internal/java
    mv $out/conf $out/conf.orig
    ln -s ${statePath}/backups $out/backups
    ln -s ${statePath}/conf $out/conf
    ln -s ${statePath}/data $out/data
    ln -s ${statePath}/logs $out/logs
    ln -s ${statePath}/temp $out/temp
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Issue tracking and project management tool for developers";
    maintainers = [ lib.maintainers.leona ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = lib.licenses.unfree;
  };
})
