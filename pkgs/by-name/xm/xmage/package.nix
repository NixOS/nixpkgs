{
  lib,
  stdenv,
  fetchurl,
  jdk8,
  unzrip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmage";
  version = "1.4.58-dev_2025-10-06_20-40";

  src = fetchurl {
    url = "http://xmage.today/files/mage-full_${finalAttrs.version}.zip";
    sha256 = "sha256-UOtxV+ykDIH+PLjLrC66Rut92IIw2iDHWwvJ2ytmUAs=";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ unzrip ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack
    unzrip $src -d "$sourceRoot"
    runHook postUnpack
  '';

  installPhase =
    let
      strVersion = lib.substring 0 6 finalAttrs.version;
    in
    ''
      mkdir -p $out/bin
      cp -rv ./* $out

      cat << EOS > $out/bin/xmage
      exec ${jdk8}/bin/java -Xms256m -Xmx1024m -XX:MaxPermSize=384m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar $out/xmage/mage-client/lib/mage-client-${strVersion}.jar
      EOS

      chmod +x $out/bin/xmage
    '';

  meta = {
    description = "Magic Another Game Engine";
    mainProgram = "xmage";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      abueide
    ];
    homepage = "http://xmage.de/";
  };

})
