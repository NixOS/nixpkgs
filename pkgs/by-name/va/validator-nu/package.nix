{
  ant,
  cacert,
  fetchFromGitHub,
  git,
  installShellFiles,
  jdk_headless,
  jre_headless,
  makeWrapper,
  maven,
  pandoc,
  python3,
  stdenvNoCC,
  lib,
  testers,
}:

let
  pname = "validator-nu";
  version = "26.5.21";

  src = fetchFromGitHub {
    owner = "validator";
    repo = "validator";
    rev = "a41fe4e78b13f65119f099c936c8e3a49459d44a";
    hash = "sha256-o0/0aFT32mXIxYyUEyAvg9fjzgwZaia7ci4J2fV7I+Y=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    nativeBuildInputs = [
      ant
      cacert
      jdk_headless
      maven
      python3
    ];

    postPatch = ''
      substituteInPlace build/build.xml \
        --replace-fail \
        'src="https://html.spec.whatwg.org/"' \
        'src="https://html.spec.whatwg.org/commit-snapshots/0aa021ab4f21a6550f1591a9cc98449aaea9eefa/"'
    '';

    buildPhase = ''
      python checker.py dldeps
      ant -f build/build.xml dl-html5spec
      # Pre-download Maven plugins needed for jing-shade
      export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"
      cat > $PWD/dummy-pom.xml << EOF
      <project>
        <modelVersion>4.0.0</modelVersion>
        <groupId>dummy</groupId>
        <artifactId>dummy</artifactId>
        <version>1.0</version>
        <build>
          <plugins>
            <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-shade-plugin</artifactId>
              <version>3.5.1</version>
            </plugin>
          </plugins>
        </build>
      </project>
      EOF
      mvn -f $PWD/dummy-pom.xml dependency:resolve-plugins 2>&1 || true
    '';

    installPhase = ''
      mkdir -p "$out" "$out/build" "$out/resources"
      mv dependencies extras "$out"
      mv resources/spec "$out/resources/spec"
      if [ -d "$PWD/.m2" ]; then
        cp -r "$PWD/.m2" "$out/"
        # Strip non-deterministic Maven metadata files
        find "$out/.m2" -type f \( -name "_remote.repositories" -o -name "resolver-status.properties" \) -delete
      fi
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-gWYiB5lw1u2K0VCQulyz3Syc1Xs3rFLSrETUzVmss+s=";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    ant
    installShellFiles
    jdk_headless
    makeWrapper
    maven
    pandoc
    python3
  ];

  postPatch = ''
    substituteInPlace build/build.py --replace-fail \
      'validatorVersion = "%s.%s.%s" % (year, month, day)' \
      'validatorVersion = "${finalAttrs.version}"'
  '';

  buildPhase = ''
    ln -s '${deps}/dependencies' '${deps}/extras' .
    mkdir -p resources
    ln -s '${deps}/resources/spec' resources/spec
    if [ -d "${deps}/.m2" ]; then
      mkdir -p "$PWD/.m2"
      cp -r "${deps}/.m2"/* "$PWD/.m2/"
      chmod -R +w "$PWD/.m2"
      export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"
    fi
    JAVA_HOME='${jdk_headless}' python checker.py --offline build
    make -C docs VNU_VERSION='${finalAttrs.version}' DATE='date -d @$(SOURCE_DATE_EPOCH)'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/java"
    mv build/dist/vnu.jar "$out/share/java/"
    installManPage docs/*.1
    makeWrapper "${jre_headless}/bin/java" "$out/bin/vnu" \
      --add-flags "-jar '$out/share/java/vnu.jar'"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Helps you catch problems in your HTML/CSS/SVG";
    homepage = "https://validator.github.io/validator/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      andersk
    ];
    mainProgram = "vnu";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
  };
})
