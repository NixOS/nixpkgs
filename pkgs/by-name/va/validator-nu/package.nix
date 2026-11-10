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
  strip-nondeterminism,
  stdenvNoCC,
  lib,
  testers,
}:

let
  pname = "validator-nu";
  version = "26.11.9.2";

  src = fetchFromGitHub {
    owner = "validator";
    repo = "validator";
    tag = version;
    hash = "sha256-9/yWPGFImFFqiKgpxcSvHFiXAKUu+SlDo5qmdfFGbg8=";
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
      strip-nondeterminism
    ];

    postPatch = ''
      substituteInPlace build/build.xml \
        --replace-fail \
        'src="https://html.spec.whatwg.org/"' \
        'src="https://html.spec.whatwg.org/commit-snapshots/24c5e48bf66ea61bc199ec6338c81258275ba9c6/"'

      python3 - <<'PY'
from pathlib import Path

path = Path("build/shade-with-maven.py")
text = path.read_text()
text = text.replace(
    'mvn_cmd, "install:install-file",',
    'mvn_cmd, "-Dmaven.repo.local=" + os.path.join(os.getcwd(), ".m2", "repository"), "install:install-file",',
)
text = text.replace(
    'cmd = [mvn_cmd, "clean", "package"]',
    'cmd = [mvn_cmd, "-Dmaven.repo.local=" + os.path.join(os.getcwd(), ".m2", "repository"), "clean", "package"]',
)
path.write_text(text)
PY
    '';

    buildPhase = ''
      export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"

      python3 checker.py dldeps
      ant -f build/build.xml dl-html5spec

      # Populate the local Maven repository with plugins and dependencies needed
      # for offline shading in the main build.
      ant -f jing-trang/build.xml jar
      python3 build/shade-with-maven.py

      # Remove artifacts produced from locally built jars so the fixed-output
      # hash stays platform-independent.
      rm -rf \
        .m2/repository/com/thaiopensource/jing \
        .m2/repository/isorelax/isorelax \
        .m2/repository/nu/validator/jing-shaded
    '';

    installPhase = ''
      mkdir -p "$out" "$out/resources"
      mv dependencies extras "$out"
      mv resources/spec "$out/resources/spec"

      if [ -d .m2 ]; then
        cp -r .m2 "$out/"
        find "$out/.m2" -type f \( \
          -name "_remote.repositories" -o \
          -name "resolver-status.properties" -o \
          -name "*.lastUpdated" \
        \) -delete
      fi

      find "$out" -type f \( -name '*.jar' -o -name '*.zip' \) -exec strip-nondeterminism {} +
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-j1DqSMRpQUPX3uaXXvek4NjtS1E6JlqLnAdZOwnBYRg=";
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

    python3 - <<'PY'
from pathlib import Path

path = Path("build/shade-with-maven.py")
text = path.read_text()
text = text.replace(
    'mvn_cmd, "install:install-file",',
    'mvn_cmd, "-o", "-Dmaven.repo.local=" + os.path.join(os.getcwd(), ".m2", "repository"), "install:install-file",',
)
text = text.replace(
    'cmd = [mvn_cmd, "clean", "package"]',
    'cmd = [mvn_cmd, "-o", "-Dmaven.repo.local=" + os.path.join(os.getcwd(), ".m2", "repository"), "clean", "package"]',
)
path.write_text(text)
PY
  '';

  buildPhase = ''
    ln -s '${deps}/dependencies' '${deps}/extras' .
    mkdir -p resources
    ln -s '${deps}/resources/spec' resources/spec

    if [ -d "${deps}/.m2" ]; then
      cp -r "${deps}/.m2" .m2
      chmod -R +w .m2
      export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"
    fi

    ant -f jing-trang/build.xml jar
    python3 build/shade-with-maven.py

    JAVA_HOME='${jdk_headless}' python3 checker.py --offline build
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
