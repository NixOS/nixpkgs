{
  lib,
  stdenvNoCC,
  runCommand,
  fetchurl,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  gradle,
  jdk,
  jre,
  opentxl,
}:
let
  # Required for bootstrapping
  umpleJar = fetchurl {
    url = "https://github.com/umple/umple/releases/download/v1.35.0/umple-1.35.0.7523.c616a4dce.jar";
    hash = "sha256-STtje3QyOWQY6/nc2Q9LCOwPkaCjJH3o27Mm4KD4C7M=";
  };

  # Not managed through Gradle
  joptSimple = fetchFromGitHub {
    owner = "jopt-simple";
    repo = "jopt-simple";
    tag = "jopt-simple-4.4";
    hash = "sha256-sOQaEq2qzvEwJzwZIcMQus3tetzA6O2VPl8XUJAtupM=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umple";
  version = "1.35.0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "umple";
    repo = "umple";
    rev = "7844b834ab178460b9e563b78ba2c02fed6451ae";
    hash = "sha256-nx6/xoc4ymbvFz5kCTiFyk7ckFx8moE6GtE+M8RXN74=";
  };

  nativeBuildInputs = [
    gradle
    jdk
    opentxl
    makeWrapper
  ];

  patches = [
    # The upstream project uses some deprecated Gradle 7 features and old dependencies
    ./gradle-8-compat.patch
    # Replaces the logic to determine the current version (depends on a flaky Git plugin)
    # with the Nix package version
    ./use-nix-version.patch
    # Patches any network-dependent tasks to use prefetched values
    ./no-network.patch
  ];

  postPatch = ''
    # Set variables from patches
    substituteInPlace build.gradle \
      --subst-var-by NIX_UMPLE_VERSION ${finalAttrs.version} \
      --subst-var-by UMPLE_JAR ${umpleJar} \
      --subst-var-by JOPT_SIMPLE_PATH "${joptSimple}/src/main/java/joptsimple"

    # Replace @UMPLE_VERSION@ template in original source code with actual version.
    # This ensures that emitted files include comments indicating the proper version,
    # e.g. "Generated with Umple x.y.z"
    find . -type f \( -name '*.jar' -o -name '*.ump' \) -exec sed -i 's/@UMPLE_VERSION@/${finalAttrs.version}/g' {} +
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "quickbuild";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp dist/gradle/libs/umple*.jar $out/bin/
    cd $out/bin/
    # Strip version suffix from filenames
    for file in *.jar; do
      mv "$file" "''${file%-${finalAttrs.version}.jar}.jar"
    done
    # Create wrappers
    for file in *.jar; do
      makeWrapper ${lib.getExe jre} "''${file%.jar}" \
        --add-flags "-jar $out/bin/$file"
    done
    cd -

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
          jdk
          jre
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

  meta = with lib; {
    description = "Model-oriented programming language and modelling tool for integrating UML constructs into high-level languages";
    mainProgram = "umple";
    platforms = platforms.all;
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with maintainers; [ MysteryBlokHed ];
  };
})
