{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  writeScript,
  installShellFiles,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "babashka-unwrapped";
  version = "1.12.209";

  src = fetchurl {
    url = "https://github.com/babashka/babashka/releases/download/v${finalAttrs.version}/babashka-${finalAttrs.version}-standalone.jar";
    sha256 = "sha256-Br8e011Iy+fr+MrIIRtcga98VSDKDeyRfgVTPnjBMII=";
  };

  nativeBuildInputs = [ installShellFiles ];

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    "--native-image-info"
    "--enable-preview"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/bb --version | fgrep '${finalAttrs.version}'
    $out/bin/bb '(+ 1 2)' | fgrep '3'
    $out/bin/bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]' | fgrep '[1 2]'
    $out/bin/bb '(prn "bépo àê")' | fgrep 'bépo àê'
    $out/bin/bb '(:out (babashka.process/sh "echo" "ä"))' | fgrep 'ä'
    $out/bin/bb '(into-array [:f])'

    runHook postInstallCheck
  '';

  postInstall = ''
    installShellCompletion --cmd bb --bash ${./completions/bb.bash}
    installShellCompletion --cmd bb --zsh ${./completions/bb.zsh}
    installShellCompletion --cmd bb --fish ${./completions/bb.fish}
  '';

  passthru.updateScript = writeScript "update-babashka" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq libarchive

    set -euo pipefail
    shopt -s inherit_errexit

    latest_version="$(curl \
      ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -fsL "https://api.github.com/repos/babashka/babashka/releases/latest" \
      | jq -r '.tag_name')"

    if [ "$(update-source-version babashka-unwrapped "''${latest_version/v/}" --print-changes)" = "[]" ]; then
      # no need to update babashka.clojure-tools when babashka-unwrapped wasn't updated
      exit 0
    fi

    clojure_tools_version=$(curl \
      -fsL \
      "https://github.com/babashka/babashka/releases/download/''${latest_version}/babashka-''${latest_version/v/}-standalone.jar" \
      | bsdtar -qxOf - borkdude/deps.clj \
      | ${lib.getExe finalAttrs.finalPackage} -I -o -e "(or (some->> *input* (filter #(= '(def version) (take 2 %))) first last last last) (throw (ex-info \"Couldn't find expected '(def version ...)' form in 'borkdude/deps.clj'.\" {})))")

    update-source-version babashka.clojure-tools "$clojure_tools_version" \
      --file="pkgs/development/interpreters/babashka/clojure-tools.nix"
  '';

  meta = {
    description = "Clojure babushka for the grey areas of Bash";
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
    changelog = "https://github.com/babashka/babashka/blob/v${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    mainProgram = "bb";
    maintainers = with lib.maintainers; [
      bandresen
      bhougland
      DerGuteMoritz
      jlesquembre
    ];
  };
})
