{
  lib,
  stdenv,
  fetchurl,
  jdk8,
  unzrip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmage";
  version = "1.4.60-dev_2026-06-28_13-19";

  src = fetchurl {
    url = "https://xmage.today/files/mage-full_${finalAttrs.version}.zip";
    sha256 = "sha256-n6g38rE19ZSyipoOp3cnLTsJirLRXeLF1ft7gvx3bVs=";
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
