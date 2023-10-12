{ stdenvNoCC
, lib
, babashka-unwrapped
, callPackage
, makeWrapper
, rlwrap
, clojureToolsBabashka ? callPackage ./clojure-tools.nix { }
, jdkBabashka ? clojureToolsBabashka.jdk

  # rlwrap is a small utility to allow the editing of keyboard input, see
  # https://book.babashka.org/#_repl
  #
  # NOTE In some cases, rlwrap prints some extra empty lines. That behavior can
  # break some babashka scripts. For this reason, it is disabled by default. See:
  # https://github.com/NixOS/nixpkgs/issues/246839
  # https://github.com/NixOS/nixpkgs/pull/248207
, withRlwrap ? false
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "babashka";
  inherit (babashka-unwrapped) version meta doInstallCheck;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let unwrapped-bin = "${babashka-unwrapped}/bin/bb"; in
    ''
      mkdir -p $out/clojure_tools
      ln -s -t $out/clojure_tools ${clojureToolsBabashka}/*.edn
      ln -s -t $out/clojure_tools ${clojureToolsBabashka}/libexec/*

      makeWrapper "${babashka-unwrapped}/bin/bb" "$out/bin/bb" \
        --inherit-argv0 \
        --set-default DEPS_CLJ_TOOLS_DIR $out/clojure_tools \
        --set-default JAVA_HOME ${jdkBabashka}

    '' +
    lib.optionalString withRlwrap ''
      substituteInPlace $out/bin/bb \
        --replace '"${unwrapped-bin}"' '"${rlwrap}/bin/rlwrap" "${unwrapped-bin}"'
    '';

  installCheckPhase = ''
    ${babashka-unwrapped.installCheckPhase}
    # Needed for Darwin compat, see https://github.com/borkdude/deps.clj/issues/114
    export CLJ_CONFIG="$TMP/.clojure"
    $out/bin/bb clojure --version | grep -wF '${clojureToolsBabashka.version}'
  '';

  passthru.unwrapped = babashka-unwrapped;
  passthru.clojure-tools = clojureToolsBabashka;
})
