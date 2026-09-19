{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk17,
  jre_headless,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vineflower";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Vineflower";
    repo = "vineflower";
    tag = finalAttrs.version;

    hash = "sha256-G61k7UmO5bZ3PdSKC596YqFhWGqSMml64jeRQ7CKNT4=";
  };

  nativeBuildInputs = [
    gradle_9
    jdk17
    makeWrapper
  ];

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true; # required by mitm-cache on Darwin

  gradleBuildTask = "allJar";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail \
        'version = version + (ENV.GITHUB_ACTIONS ? "" : "+local")' \
        ""
  '';

  # The upstream test suite compiles fixtures with several Java versions and
  # downloads toolchains through Foojay. Only the distribution JAR is needed
  # here, and the required test toolchains are not available in the sandbox.
  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/vineflower --help \
      | grep -F "Vineflower Decompiler ${finalAttrs.version}"

    runHook postInstallCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 \
      build/libs/vineflower-${finalAttrs.version}.jar \
      $out/share/vineflower/vineflower.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/vineflower \
      --add-flags "-jar $out/share/vineflower/vineflower.jar"

    runHook postInstall
  '';

  meta = {
    description = "Modern Java decompiler";
    homepage = "https://vineflower.org/";
    license = lib.licenses.asl20;
    mainProgram = "vineflower";
    maintainers = with lib.maintainers; [ macbucheron ];

    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];

    inherit (jre_headless.meta) platforms;
  };
})
