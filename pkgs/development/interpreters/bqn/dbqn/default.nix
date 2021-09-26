{ stdenvNoCC
, stdenv
, lib
, fetchFromGitHub
, jre
, makeWrapper
# Whether to use GraalVM's native image feature to make a standalone
# executable called "nbqn". This starts faster, but can't compile BQN to
# JVM bytecode.
, useNativeImage ? false
, graalvm11-ce
# for passthru.tests
, dbqn
}:

let
  java = if useNativeImage then graalvm11-ce else jre;
  useStdenv = if useNativeImage then stdenv else stdenvNoCC;
in

useStdenv.mkDerivation {
  pname = "dbqn" + lib.optionalString useNativeImage "-native";
  version = "unstable-2021-09-03";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN";
    rev = "41dc26f5e9b1adca618a77e6774953c7288cbce0";
    sha256 = "14vb0k4vjx2f7vgp9sbvgq76v6ljlw2vihs8sqhjfgad1kw2mrkn";
  };

  nativeBuildInputs = [
    java
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs --build build8

    # Need to set locale to stop java complaining about UTF-8 chars
    # Build 8 is for Java > 8, ironically
    env LC_ALL=C.UTF-8 ./build8

  '' + lib.optionalString useNativeImage ''
    native-image --report-unsupported-elements-at-runtime -jar BQN.jar nbqn
  '' + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  '' + (if !useNativeImage then ''
    install -Dm644 BQN.jar -t "$out/share/dbqn"

    # script interpreter
    makeWrapper "${lib.getBin java}/bin/java" "$out/bin/dbqn" \
      --add-flags "-jar $out/share/dbqn/BQN.jar -f"

    # repl
    makeWrapper "${lib.getBin java}/bin/java" "$out/bin/dbqn-repl" \
      --add-flags "-jar $out/share/dbqn/BQN.jar -r"
  '' else ''
    install -Dm755 nbqn -t "$out/bin"

    # wrappers like above
    makeWrapper "$out/bin/nbqn" "$out/bin/dbqn" --add-flags "-f"
    makeWrapper "$out/bin/nbqn" "$out/bin/dbqn-repl" --add-flags "-r"
  '') + ''
    runHook postInstall
  '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    # Only prints results, so we need to check success
    "$out/bin/dbqn" ./test/test | tee /dev/stderr | grep -v "Passed all" && exit 1

    runHook postInstallCheck
  '';

  meta = {
    description = "A BQN implementation based on dzaima/APL"
      + lib.optionalString useNativeImage ", compiled as a GraalVM native image";
    license = lib.licenses.mit;
    platforms = java.meta.platforms;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/dzaima/BQN";
  };
}
