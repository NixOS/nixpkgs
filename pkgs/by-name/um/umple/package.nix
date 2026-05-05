{
  lib,
  stdenvNoCC,
  runCommand,
  fetchurl,
  fetchFromGitHub,
  gradle_8, # incompatible with gradle 9+
  installShellFiles,
  makeWrapper,
  nix-update-script,
  opentxl,
  jre,
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

  version = "1.37.0-unstable-2026-04-25";
  numericVersion = lib.head (lib.splitString "-" version);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umple";
  inherit version;

  src = fetchFromGitHub {
    owner = "umple";
    repo = "umple";
    rev = "98d4c08c5bbb171c94abf60fec92214448eb5a6d";
    hash = "sha256-MLhICAjwXUkDwqIDxMz2+VnRC36ckmIVkOivZTpxWPE=";
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

  patches = [
    # The upstream project uses some deprecated Gradle 7 features and old dependencies
    ./gradle-8-compat.patch
    # Replaces the logic to determine the current version (requires Git at runtime)
    ./replace-version.patch
    # Fixes broken working directory + updates Jar paths for manpage generation task
    ./fix-manpage.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gradle_8
    gradle_8.jdk
    installShellFiles
    makeWrapper
    opentxl
  ];

  postPatch = ''
    gitCommit=$(<COMMIT)
    gitCommitCount=$(<COMMIT_COUNT)
    umpleVersion="${numericVersion}.$gitCommitCount.$gitCommit"

    # Set variables from patches + use Nix store paths
    substituteInPlace build.gradle \
      --replace-fail @UMPLE_VERSION@ "$umpleVersion" \
      --replace-fail @UMPLE_OUT_JAR@ "umple-$umpleVersion.jar" \
      --replace-fail '${"$"}{rootProject.projectDir.toString()}/libs/umple-latest.jar' '${umpleJar}' \
      --replace-fail '${"$"}{rootProject.projectDir.toString()}/dist/gradle/libs/vendors/jopt-simple-jopt-simple-4.4/src/main/java/joptsimple' '${joptSimple}/src/main/java/joptsimple'

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

  gradleFlags = [
    # Network-dependent tasks
    "--exclude-task=downloadUmpleJar"
    "--exclude-task=downloadJOptSimpleVendorZip"
    "--exclude-task=downloadAndUnzipJOptSimpleVendor"
    "--exclude-task=prepareJOptSimpleVendor"
    # Tasks that try to modify readonly files
    "--exclude-task=cleanUpUmple"
  ];

  postBuild = ''
    gradle --no-daemon genManpage
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/java}
    cp dist/gradle/libs/umple*.jar $out/share/java
    installManPage build/package-files/umple.1

    pushd $out/share/java
    # Strip version suffix from filenames
    for file in *.jar; do
      mv "$file" "''${file%-$umpleVersion.jar}.jar"
    done
    # Create wrappers
    for file in *.jar; do
      makeWrapper ${lib.getExe jre} "$out/bin/''${file%.jar}" \
        --add-flags "-jar $out/share/java/$file"
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
        javac -d bin Shapes/core/*.java
        java -cp bin Shapes.core.Shape2D
        touch $out
      '';

  meta = {
    description = "Model-oriented programming language and modelling tool for integrating UML constructs into high-level languages";
    mainProgram = "umple";
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
