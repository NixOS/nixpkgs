{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeBinaryWrapper,
  jdk17,
  jre_headless,
  nix-update-script,
  versionCheckHook,
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

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;

  # Upstream appends "+local" to the version unless GITHUB_ACTIONS is set,
  # which would leak into both the jar name and the manifest.
  env.GITHUB_ACTIONS = "true";

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk17}"
    # Disable foojay resolver trying to download JDKs.
    "-Porg.gradle.java.installations.auto-download=false"
  ];

  # There is a full and a slim version. "allJar" builds the full one, bundling
  # the plugins into META-INF/plugins; the default "jar" task only builds slim.
  gradleBuildTask = "allJar";

  # The test suite compiles its test data against the JDK 8, 9, 11, 16, 21 and
  # 25 toolchains. Upstream runs these in CI before tagging a release.
  doCheck = false;

  gradleUpdateScript = ''
    runHook preBuild

    gradle allJar
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/vineflower-${finalAttrs.version}.jar \
      $out/share/vineflower/vineflower.jar
    makeWrapper ${lib.getExe jre_headless} $out/bin/vineflower \
      --add-flags "-jar $out/share/vineflower/vineflower.jar"

    runHook postInstall
  '';

  # There is no --version flag. The help --help prints the version in its banner.
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JVM language decompiler";
    longDescription = ''
      Modern Java decompiler aiming to be as accurate as possible,
      with an emphasis on output quality. Fork of the Fernflower decompiler.
    '';
    mainProgram = "vineflower";
    homepage = "https://vineflower.org/";
    changelog = "https://github.com/Vineflower/vineflower/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.zdrng ];
    inherit (jre_headless.meta) platforms;
  };
})
