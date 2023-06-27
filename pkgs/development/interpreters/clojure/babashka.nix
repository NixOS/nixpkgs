{ lib
, buildGraalvmNativeImage
, graalvmCEPackages
, removeReferencesTo
, fetchurl
, writeScript }:

buildGraalvmNativeImage rec {
  pname = "babashka";
  version = "1.3.181";

  src = fetchurl {
    url = "https://github.com/babashka/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-NzchlHRxOCSyUf9U0Jv8h4bgKd2Jwp+LmxIfeV8+8+M=";
  };

  graalvmDrv = graalvmCEPackages.graalvm19-ce;

  executable = "bb";

  nativeBuildInputs = [ removeReferencesTo ];

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    "--native-image-info"
    "--enable-preview"
  ];

  installCheckPhase = ''
    $out/bin/bb --version | grep '${version}'
    $out/bin/bb '(+ 1 2)' | grep '3'
    $out/bin/bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]' | grep '[1 2]'
  '';

  # As of v1.2.174, this will remove references to ${graalvmDrv}/conf/chronology,
  # not sure the implications of this but this file is not available in
  # graalvm19-ce anyway.
  postInstall = ''
    remove-references-to -t ${graalvmDrv} $out/bin/${executable}
  '';

  passthru.updateScript = writeScript "update-babashka" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -euo pipefail

    readonly latest_version="$(curl \
      ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -s "https://api.github.com/repos/babashka/babashka/releases/latest" \
      | jq -r '.tag_name')"

    # v0.6.2 -> 0.6.2
    update-source-version babashka "''${latest_version/v/}"
  '';

  meta = with lib; {
    description = "A Clojure babushka for the grey areas of Bash";
    longDescription = ''
      The main idea behind babashka is to leverage Clojure in places where you
      would be using bash otherwise.

      As one user described it:

          I’m quite at home in Bash most of the time, but there’s a substantial
          grey area of things that are too complicated to be simple in bash, but
          too simple to be worth writing a clj/s script for. Babashka really
          seems to hit the sweet spot for those cases.

    Goals:

    - Low latency Clojure scripting alternative to JVM Clojure.
    - Easy installation: grab the self-contained binary and run. No JVM needed.
    - Familiarity and portability:
      - Scripts should be compatible with JVM Clojure as much as possible
      - Scripts should be platform-independent as much as possible. Babashka
        offers support for linux, macOS and Windows.
    - Allow interop with commonly used classes like java.io.File and System
    - Multi-threading support (pmap, future, core.async)
    - Batteries included (tools.cli, cheshire, ...)
    - Library support via popular tools like the clojure CLI
    '';
    homepage = "https://github.com/babashka/babashka";
    changelog = "https://github.com/babashka/babashka/blob/v${version}/CHANGELOG.md";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    maintainers = with maintainers; [
      bandresen
      bhougland
      DerGuteMoritz
      jlesquembre
      thiagokokada
    ];
  };
}
