{ lib, buildGraalvmNativeImage, fetchurl, writeScript }:

buildGraalvmNativeImage rec {
  pname = "babashka";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/babashka/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-bRuf9qUBgb+1Sr2US67NZZrrb2MycSvNbekLLSpvZss=";
  };

  executable = "bb";

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    "--native-image-info"
  ];

  installCheckPhase = ''
    $out/bin/bb --version | grep '${version}'
    $out/bin/bb '(+ 1 2)' | grep '3'
    $out/bin/bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]' | grep '[1 2]'
  '';

  passthru.updateScript = writeScript "update-babashka" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -euo pipefail

    readonly latest_version="$(curl \
      ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
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
