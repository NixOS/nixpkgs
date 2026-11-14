{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  mill,
  protobuf,
  jdk17,
  gitMinimal,
}:

let
  # VerCors builds its viper/silver/silicon/carbon modules with Scala 2.13.10,
  # whose compiler cannot parse JDK 21 class files, so run mill on JDK 17.
  # The mill version is locked because an update changes the fetched internal
  # dependencies, which would invalidate the deps fixed-output derivation.
  lockedMill = (mill.override { jre = jdk17; }).overrideAttrs (oldAttrs: rec {
    # matches the version listed inside the `.mill-version` file of the source
    version = "0.11.7";
    src = fetchurl {
      url = "https://github.com/com-lihaoyi/mill/releases/download/${version}/${version}-assembly";
      hash = "sha256-iijKZlQoiIWos+Kdq9hIgiM5yM7xCf11abrJ71LO9jA=";
    };
  });

  z3Jar = fetchurl {
    url = "https://www.sosy-lab.org/ivy/org.sosy_lab/javasmt-solver-z3/com.microsoft.z3-4.8.7.jar";
    hash = "sha256-8m0rf45wn8XL/YAEwmOzVwy2D1P6V1qG+6y5V/qto9U=";
  };

  antlrJar = fetchurl {
    url = "https://github.com/pieter-bos/antlr4/releases/download/4.8-extractors-2/antlr4.jar";
    hash = "sha256-17X/5ofTuB1cYypCAZbEzsioSQ2K4/tCFoeauyq/46g=";
  };

  silverSrc = fetchFromGitHub {
    owner = "viperproject";
    repo = "silver";
    rev = "e7ce7757caff264b17e54f5c4fecedc77862c9ad";
    hash = "sha256-0bfGys6gv3k5v2r9pjtvj3adma+Se2roRuzBqFtObNs=";
  };

  siliconSrc = fetchFromGitHub {
    owner = "viperproject";
    repo = "silicon";
    rev = "2af1a000401a30ddc80eb482111df6662c4e49d3";
    hash = "sha256-CliwbcnbbbL9H2hHy6ytEp8d7jAcuUp3F9Uo1TE94DU=";
  };

  carbonSrc = fetchFromGitHub {
    owner = "viperproject";
    repo = "carbon";
    rev = "7c5c1df49844ce2cd27d42d4d95859bbc3ad0142";
    hash = "sha256-pgHW1S3xhFxqqOYQxDul+qwJw90VSRkFwhKF7DHUVzA=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vercors";
  version = "2.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "utwente-fmt";
    repo = "vercors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CQUuMrM0TfPObPuWwBpdZLgR+lus/FY4I5CE8jnBvVk=";
  };

  patches = [ ./offline-build.patch ];

  deps = stdenvNoCC.mkDerivation {
    name = "vercors-${finalAttrs.version}-deps";

    inherit (finalAttrs) src patches;

    nativeBuildInputs = [ lockedMill ];

    buildPhase = ''
      runHook preBuild

      export JAVA_TOOL_OPTIONS="-Duser.home=$(mktemp -d)"
      export COURSIER_CACHE=$out/.coursier

      mill __.prepareOffline --all
      mill vercors.hre.pprofProto.scalaPBClasspath

      runHook postBuild
    '';

    outputHash = "sha256-Z9ZyEG/C3k8iMeHXjN/lBWZIvIVSTxaFqvJApCTZhkY=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    lockedMill
    protobuf
    gitMinimal
  ];

  buildPhase = ''
    runHook preBuild

    home=$(mktemp -d)
    export JAVA_TOOL_OPTIONS="-Duser.home=$home"
    export COURSIER_CACHE=$home/.coursier

    cp -r ${finalAttrs.deps}/.coursier $COURSIER_CACHE
    chmod -R u+w $COURSIER_CACHE

    export VERCORS_VERSION=${finalAttrs.version}
    export PROTOC=${protobuf}/bin/protoc
    export VERCORS_Z3_JAR=${z3Jar}
    export VERCORS_ANTLR_JAR=${antlrJar}
    export VERCORS_GIT_E7CE7757CAFF264B17E54F5C4FECEDC77862C9AD=${silverSrc}
    export VERCORS_GIT_2AF1A000401A30DDC80EB482111DF6662C4E49D3=${siliconSrc}
    export VERCORS_GIT_7C5C1DF49844CE2CD27D42D4D95859BBC3AD0142=${carbonSrc}

    mill vercors.main.unixTar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vercors
    tar -xJf out/vercors/main/unixTar.dest/vercors-*-unix.tar.xz -C $out/share/vercors

    cat > $out/share/vercors/.classpath <<EOF
    -cp $out/share/vercors/vercors.jar:$out/share/vercors/res:$out/share/vercors/deps
    EOF

    cat > $out/share/vercors/vercors <<EOF
    #!/bin/sh
    ${jdk17}/bin/java -Xms1G -Xss256m @$out/share/vercors/.classpath vct.main.Main "\$@"
    EOF

    mkdir -p $out/bin
    ln -s $out/share/vercors/vercors $out/bin/vercors

    runHook postInstall
  '';

  meta = {
    description = "Deductive verifier for concurrent and parallel software";
    homepage = "https://vercors.ewi.utwente.nl/";
    changelog = "https://github.com/utwente-fmt/vercors/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "vercors";
    maintainers = with lib.maintainers; [ luc65r ];
    platforms = lib.platforms.all;
  };
})
