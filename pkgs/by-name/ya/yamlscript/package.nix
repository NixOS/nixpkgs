{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "yamlscript";
  version = "0.1.41";

  src = fetchurl {
    url = "https://github.com/yaml/yamlscript/releases/download/${version}/yamlscript.cli-${version}-standalone.jar";
    hash = "sha256-/Kke7MH0DsBpo8AEIr8XVDKqbSshz0Ql8S5KzrPB9jk=";
  };

  executable = "ys";

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
    $out/bin/ys  -e 'say: (+ 1 2)' | fgrep 3
  '';

  meta = with lib; {
    description = "Programming in YAML";
    homepage = "https://github.com/yaml/yamlscript";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    mainProgram = "ys";
    maintainers = with maintainers; [ sgo ];
  };
}
