{
  stdenv,
  fetchFromGitHub,
  lib,
  vlang,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v-analyzer";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-g+MIRWJoipDnngISWEmYvshJZKWHXI0IGJu+S3FXbXg=";
  };

  nativeBuildInputs = [
    vlang
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p bin
    v -prod . -o bin/v-analyzer

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/v-analyzer $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "The @vlang language server, for all your editing needs like go-to-definition, code completion, type hints, and more";
    homepage = "https://github.com/vlang/v-analyzer";
    changelog = "https://github.com/vlang/v-analyzer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cilki ];
    platforms = lib.platforms.unix;
    mainProgram = "v-analyzer";
  };
})
