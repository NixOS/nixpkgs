{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "yamlscript";
  version = "0.2.24";

  src = fetchurl {
    url = "https://github.com/yaml/yamlscript/releases/download/${finalAttrs.version}/yamlscript.cli-${finalAttrs.version}-standalone.jar";
    hash = "sha256-2MwHgFdWk6OEzi3RihhLxB286zVn/g+n1+TPzRIb13Q=";
  };

  extraNativeImageBuildArgs = [
    "--native-image-info"
    "--no-fallback"
    "--initialize-at-build-time"
    "--enable-preview"
    "-H:+ReportExceptionStackTraces"
    "-H:IncludeResources=SCI_VERSION"
    "-H:Log=registerResource:"
    "-J-Dclojure.spec.skip-macros=true"
    "-J-Dclojure.compiler.direct-linking=true"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/ys -e 'say: (+ 1 2)' | fgrep 3

    runHook postInstallCheck
  '';

  meta = {
    description = "Programming in YAML";
    homepage = "https://github.com/yaml/yamlscript";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    mainProgram = "ys";
    maintainers = with lib.maintainers; [ sgo ];
  };
})
