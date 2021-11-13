{ lib, stdenv, fetchurl, graalvm11-ce, glibcLocales, writeScript }:

stdenv.mkDerivation rec {
  pname = "babashka";
  version = "0.6.4";

  src = fetchurl {
    url = "https://github.com/babashka/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-/ULBnC10lAYHYD0P0HGWEcCAqkX8IRcQ7W5ulho+JUM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ graalvm11-ce glibcLocales ];

  LC_ALL = "en_US.UTF-8";
  BABASHKA_JAR = src;
  BABASHKA_BINARY = "bb";
  BABASHKA_XMX = "-J-Xmx4500m";

  buildPhase = ''
    runHook preBuild

    # https://github.com/babashka/babashka/blob/v0.6.2/script/compile#L41-L52
    args=("-jar" "$BABASHKA_JAR"
          "-H:CLibraryPath=${graalvm11-ce.lib}/lib"
          # Required to build babashka on darwin. Do not remove.
          "${lib.optionalString stdenv.isDarwin "-H:-CheckToolchain"}"
          "-H:Name=$BABASHKA_BINARY"
          "-H:+ReportExceptionStackTraces"
          # "-H:+PrintAnalysisCallTree"
          # "-H:+DashboardAll"
          # "-H:DashboardDump=reports/dump"
          # "-H:+DashboardPretty"
          # "-H:+DashboardJson"
          "--verbose"
          "--no-fallback"
          "--native-image-info"
          "$BABASHKA_XMX")

     native-image ''${args[@]}

     runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bb $out/bin/bb

    runHook postInstall
  '';

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
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [
      bandresen
      bhougland
      DerGuteMoritz
      jlesquembre
      thiagokokada
    ];
  };
}
