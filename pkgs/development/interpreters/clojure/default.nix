{ lib, stdenv, fetchurl, installShellFiles, jdk, rlwrap, makeWrapper, writeScript }:

stdenv.mkDerivation (finalAttrs: {
  pname = "clojure";
  version = "1.11.4.1474";

  src = fetchurl {
    # https://github.com/clojure/brew-install/releases
    url = "https://github.com/clojure/brew-install/releases/download/${finalAttrs.version}/clojure-tools-${finalAttrs.version}.tar.gz";
    hash = "sha256-sNFDXvrHMrFgLrBHmbv3DKOXuNu6u1OqcmlqZNX/EAg=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # See https://github.com/clojure/brew-install/blob/1.10.3/src/main/resources/clojure/install/linux-install.sh
  installPhase =
    let
      binPath = lib.makeBinPath [ rlwrap jdk ];
    in
    ''
      runHook preInstall

      clojure_lib_dir=$out
      bin_dir=$out/bin

      echo "Installing libs into $clojure_lib_dir"
      install -Dm644 deps.edn "$clojure_lib_dir/deps.edn"
      install -Dm644 example-deps.edn "$clojure_lib_dir/example-deps.edn"
      install -Dm644 tools.edn "$clojure_lib_dir/tools.edn"
      install -Dm644 exec.jar "$clojure_lib_dir/libexec/exec.jar"
      install -Dm644 clojure-tools-${finalAttrs.version}.jar "$clojure_lib_dir/libexec/clojure-tools-${finalAttrs.version}.jar"

      echo "Installing clojure and clj into $bin_dir"
      substituteInPlace clojure --replace PREFIX $out
      substituteInPlace clj --replace BINDIR $bin_dir
      install -Dm755 clojure "$bin_dir/clojure"
      install -Dm755 clj "$bin_dir/clj"

      wrapProgram $bin_dir/clojure --prefix PATH : $out/bin:${binPath}
      wrapProgram $bin_dir/clj --prefix PATH : $out/bin:${binPath}

      installManPage clj.1 clojure.1

      runHook postInstall
    '';

  doInstallCheck = true;

  installCheckPhase = ''
    CLJ_CONFIG=$TMPDIR CLJ_CACHE=$TMPDIR/.clj_cache $out/bin/clojure \
      -Spath \
      -Sverbose \
      -Scp $out/libexec/clojure-tools-${finalAttrs.version}.jar
  '';

  passthru.updateScript = writeScript "update-clojure" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -euo pipefail
    shopt -s inherit_errexit

    # `jq -r '.[0].name'` results in `v0.0`
    latest_version="$(curl \
      ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -fsL "https://api.github.com/repos/clojure/brew-install/tags" \
      | jq -r '.[1].name')"

    update-source-version clojure "$latest_version"
  '';

  passthru.jdk = jdk;

  meta = with lib; {
    description = "Lisp dialect for the JVM";
    homepage = "https://clojure.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    longDescription = ''
      Clojure is a dynamic programming language that targets the Java
      Virtual Machine. It is designed to be a general-purpose language,
      combining the approachability and interactive development of a
      scripting language with an efficient and robust infrastructure for
      multithreaded programming. Clojure is a compiled language - it
      compiles directly to JVM bytecode, yet remains completely
      dynamic. Every feature supported by Clojure is supported at
      runtime. Clojure provides easy access to the Java frameworks, with
      optional type hints and type inference, to ensure that calls to Java
      can avoid reflection.

      Clojure is a dialect of Lisp, and shares with Lisp the code-as-data
      philosophy and a powerful macro system. Clojure is predominantly a
      functional programming language, and features a rich set of immutable,
      persistent data structures. When mutable state is needed, Clojure
      offers a software transactional memory system and reactive Agent
      system that ensure clean, correct, multithreaded designs.
    '';
    maintainers = with maintainers; [ jlesquembre thiagokokada ];
    platforms = platforms.unix;
  };
})
