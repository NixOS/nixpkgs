{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk11,
  makeWrapper,
  stripJavaArchivesHook,
  testers,
}:

let
  pname = "textidote";
  version = "0.8.3";
  # We can't compile with > Java 11 yet because that's the last version that supports targeting Java 6
  jdk = jdk11;

  # Manually create a fixed-output derivation to populate the dependencies for the rest of the build
  # The Ant buildscript downloads dependencies and stores them alongside the source code in a non-standard way
  # https://github.com/sylvainhalle/AntRun
  populated-src = stdenv.mkDerivation {
    pname = "textidote-populated-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "sylvainhalle";
      repo = "textidote";
      rev = "refs/tags/v${version}";
      hash = "sha256-QMSoxk5jDn6qsdxffXJ/S4eTIzLjJdAEbdaK8MZIavI=";
    };

    nativeBuildInputs = [
      ant
      jdk
    ];

    # Only run dependency-downloading tasks here to pre-download the dependencies for later
    buildPhase = ''
      runHook preBuild

      ant download-deps junit jacoco

      runHook postBuild
    '';

    # Copy the entire directory to the output including sources and resolved dependencies
    installPhase = ''
      runHook preInstall

      cp -a . $out

      runHook postInstall
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-LrFClt8zN/ma42+Yoqwoy03TCuC3JfAeb02vehkljBo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = populated-src;

  nativeBuildInputs = [
    ant
    makeWrapper
    stripJavaArchivesHook
  ];

  buildInputs = [
    jdk
  ];

  # `javac` encoding only defaults to UTF-8 after Java 18
  env.ANT_OPTS = "-Dfile.encoding=utf8";

  buildPhase = ''
    runHook preBuild

    ant jar

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ant test

    runHook postCheck
  '';

  # Recreates the wrapper from the `.deb`
  # The `.deb` seems to be manually created for every release; there's no script in the repo
  installPhase = ''
    runHook preInstall

    install -Dm644 textidote.jar $out/share/textidote/textidote.jar

    makeWrapper ${lib.getExe jdk} $out/bin/textidote \
      --add-flags "-jar $out/share/textidote/textidote.jar --name textidote"

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "TeXtidote v${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://sylvainhalle.github.io/textidote/";
    downloadPage = "https://github.com/sylvainhalle/textidote/releases";
    description = "Correction tool for LaTeX documents";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ magneticflux- ];
    mainProgram = "textidote";
    inherit (jdk.meta) platforms;
  };
})
