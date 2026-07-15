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
  version = "2026.2.17012";

  src = dockerTools.exportImage {
    diskSize = 8192;
    fromImage = dockerTools.pullImage {
      imageName = "jetbrains/youtrack";
      arch = "amd64";
      imageDigest = "sha256:fa50e2e07435dc91461c00ef05ee064ff76748d4d8feaf8aeaa9f9e4a9bf6606";
      hash = "sha256-8hoMtFqG5T4gnMDorIe6UXs/d3z7epAS352reipPjWI=";
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
    rmdir $out/{backups,data,logs,temp}
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
    platforms = [ "x86_64-linux" ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = lib.licenses.unfree;
  };
})
