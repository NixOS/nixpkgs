{
  lib,
  stdenvNoCC,
  runCommand,
  fetchurl,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  gradle_8, # incompatible with gradle 9+
  jre,
  opentxl,
}:
let
  # Required for bootstrapping
  umpleJar = fetchurl {
    url = "https://github.com/umple/umple/releases/download/v1.36.0/umple-1.36.0.8088.f0fbd82bc.jar";
    hash = "sha256-vCnGCkv2USAJcpXzR6sgCFsL43ZmHWd5+NOA8+lHBhg=";
  };

  # Not managed through Gradle
  joptSimple = fetchFromGitHub {
    owner = "jopt-simple";
    repo = "jopt-simple";
    tag = "jopt-simple-4.4";
    hash = "sha256-sOQaEq2qzvEwJzwZIcMQus3tetzA6O2VPl8XUJAtupM=";
  };

  version = "1.36.0-unstable-2026-03-13";
  numericVersion = lib.head (lib.splitString "-" version);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umple";
  inherit version;

  src = fetchFromGitHub {
    owner = "umple";
    repo = "umple";
    rev = "52df31b925e0dfb9dcebd4a95c6270d6e45f05a1";
    hash = "sha256-IBUeRaGVRN3w5l+wW/kOxvdvcLksiLx9cuBNlx4DQ+g=";
    deepClone = true;

    # Store Git info used to generate Umple unstable version
    postFetch = ''
      cd $out
      git rev-parse --short HEAD > COMMIT
      git rev-list --count HEAD > COMMIT_COUNT
      rm -rf .git
      cd -
    '';
  };

  nativeBuildInputs = [
    gradle_8
    gradle_8.jdk
    opentxl
    makeWrapper
  ];

  patches = [
    # The upstream project uses some deprecated Gradle 7 features and old dependencies
    ./gradle-8-compat.patch
    # Replaces the logic to determine the current version (requires Git at runtime)
    ./replace-version.patch
    # Patches network-dependent tasks to use prefetched values
    ./no-network.patch
    # Fixes broken working directory + updates Jar paths for manpage generation task
    ./fix-manpage.patch
  ];

  postPatch = ''
    gitCommit=$(<COMMIT)
    gitCommitCount=$(<COMMIT_COUNT)
    umpleVersion="${numericVersion}.$gitCommitCount.$gitCommit"

    # Set variables from patches
    substituteInPlace build.gradle \
      --replace-fail @UMPLE_VERSION@ "$umpleVersion" \
      --replace-fail @UMPLE_JAR@ ${umpleJar} \
      --replace-fail @UMPLE_OUT_JAR@ "umple-$umpleVersion.jar" \
      --replace-fail @JOPT_SIMPLE_PATH@ "${joptSimple}/src/main/java/joptsimple"

    # Replace outdated version in manpage
    substituteInPlace build/package-files/template.1 \
      --replace-warn 1.31.1 "$umpleVersion"

    # Replace @UMPLE_VERSION@ template in original source code with actual version.
    # This ensures that emitted files include comments indicating the proper version,
    # e.g. "Generated with Umple x.y.z"
    find . -type f \( -name '*.java' -o -name '*.ump' \) -exec sed -i "s/@UMPLE_VERSION@/$umpleVersion/g" {} +
  '';

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "quickbuild";

  postBuild = ''
    gradle --no-daemon genManpage
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/man/man1}
    cp dist/gradle/libs/umple*.jar $out/bin/
    cp build/package-files/umple.1 $out/share/man/man1/

    pushd $out/bin/
    # Strip version suffix from filenames
    for file in *.jar; do
      mv "$file" "''${file%-$umpleVersion.jar}.jar"
    done
    # Create wrappers
    for file in *.jar; do
      makeWrapper ${lib.getExe jre} "''${file%.jar}" \
        --add-flags "-jar $out/bin/$file"
    done
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  passthru.tests."2dshapes" =
    runCommand "umple-test"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          gradle_8.jdk
        ];
        src = ./2DShapes.ump;
      }
      ''
        set -euo pipefail
        cp $src .
        umple $(basename $src)
        javac -d bin Shapes/core/Shape2D.java
        java -cp bin Shapes.core.Shape2D
        touch $out
      '';

  meta = {
    description = "Model-oriented programming language and modelling tool for integrating UML constructs into high-level languages";
    mainProgram = "umple";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    homepage = "https://github.com/umple/umple";
    downloadPage = "https://github.com/umple/umple/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
