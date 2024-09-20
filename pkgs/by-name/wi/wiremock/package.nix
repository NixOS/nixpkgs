{
  fetchurl,
  gitUpdater,
  jre,
  lib,
  makeWrapper,
  stdenvNoCC,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wiremock";
  version = "3.9.1";

  src = fetchurl {
    url = "mirror://maven/org/wiremock/wiremock-standalone/${finalAttrs.version}/wiremock-standalone-${finalAttrs.version}.jar";
    hash = "sha256-cjqIDVDTsKFFrw3wfleMLLhed/6yIx5pkcmhNmkmkSw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out"/{share/wiremock,bin}
    cp ${finalAttrs.src} "$out/share/wiremock/wiremock.jar"

    makeWrapper ${jre}/bin/java $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "-jar $out/share/wiremock/wiremock.jar"
  '';

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      package = finalAttrs.finalPackage;
    };
    updateScript = gitUpdater {
      url = "https://github.com/wiremock/wiremock.git";
      ignoredVersions = "(alpha|beta|rc).*";
    };
  };

  meta = {
    description = "Flexible tool for building mock APIs";
    homepage = "https://wiremock.org/";
    changelog = "https://github.com/wiremock/wiremock/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bobvanderlinden anthonyroussel ];
    mainProgram = "wiremock";
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
  };
})
