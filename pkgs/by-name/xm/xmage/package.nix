{
  lib,
  stdenv,
  fetchurl,
  jdk8,
  unzrip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmage";
  version = "1.4.62-dev_2026-10-03_20-47";

  src = fetchurl {
    url = "https://github.com/magefree/mage/releases/download/${finalAttrs.passthru.tag}/mage-full_${finalAttrs.version}.zip";
    hash = "sha256-0lYlGuQRVWOCM8LLIKf+yC8/Lep6Rol2aRZkxV41exY=";
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

  passthru = {
    tag = "xmage_1.4.62V1";
    updateScript = ./update.sh;
  };

  meta = {
    description = "Magic Another Game Engine";
    mainProgram = "xmage";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      abueide
    ];
    homepage = "https://xmage.today/";
    changelog = "https://github.com/magefree/mage/releases/tag/${finalAttrs.passthru.tag}";
  };
})
