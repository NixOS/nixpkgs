{ stdenv
, babashka-unwrapped
, clojure
, makeWrapper
, rlwrap

, jdkBabashka ? clojure.jdk
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "babashka";
  inherit (babashka-unwrapped) version meta doInstallCheck installCheckPhase;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let unwrapped-bin = "${babashka-unwrapped}/bin/bb"; in
    ''
      mkdir -p $out/clojure_tools
      ln -s -t $out/clojure_tools ${clojure}/*.edn
      ln -s -t $out/clojure_tools ${clojure}/libexec/*

      makeWrapper "${babashka-unwrapped}/bin/bb" "$out/bin/bb" \
        --inherit-argv0 \
        --set-default DEPS_CLJ_TOOLS_DIR $out/clojure_tools \
        --set-default JAVA_HOME ${jdkBabashka}

      substituteInPlace $out/bin/bb \
        --replace '"${unwrapped-bin}"' '"${rlwrap}/bin/rlwrap" "${unwrapped-bin}"'
    '';

  passthru.unwrapped = babashka-unwrapped;
})
