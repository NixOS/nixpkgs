{ lib
, buildGraalvmNativeImage
, graalvmCEPackages
, fetchurl
, writeScript
, installShellFiles
}:

let
  babashka-unwrapped = buildGraalvmNativeImage rec {
    pname = "babashka-unwrapped";
    version = "1.3.186";

    src = fetchurl {
      url = "https://github.com/babashka/babashka/releases/download/v${version}/babashka-${version}-standalone.jar";
      sha256 = "sha256-T7inTJHSnUySituU0fcgZ0xWjIY3yb8BlSakqym67ew=";
    };

    graalvmDrv = graalvmCEPackages.graalvm-ce;

    executable = "bb";

    nativeBuildInputs = [ installShellFiles ];

    extraNativeImageBuildArgs = [
      "-H:+ReportExceptionStackTraces"
      "--no-fallback"
      "--native-image-info"
      "--enable-preview"
    ];

    doInstallCheck = true;

    installCheckPhase = ''
      $out/bin/bb --version | fgrep '${version}'
      $out/bin/bb '(+ 1 2)' | fgrep '3'
      $out/bin/bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]' | fgrep '[1 2]'
      $out/bin/bb '(prn "bépo àê")' | fgrep 'bépo àê'
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
        | ${babashka-unwrapped}/bin/bb -I -o -e "(or (some->> *input* (filter #(= '(def version) (take 2 %))) first last last last) (throw (ex-info \"Couldn't find expected '(def version ...)' form in 'borkdude/deps.clj'.\" {})))")

      update-source-version babashka.clojure-tools "$clojure_tools_version" \
        --file="pkgs/development/interpreters/babashka/clojure-tools.nix"
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
  };
in
babashka-unwrapped
