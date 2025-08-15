{
  stdenv,
  fetchFromGitHub,
  lib,
  vlang,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "0.0.6-unstable-2025-07-08";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v-analyzer";
    rev = "236d51bba1bccd57fd2950956fbffe5fe0248735";
    fetchSubmodules = true;
    hash = "sha256-F03iaRtGwFtn5gV/+s98TyX6CKzmIVYjnZgo5umArTw=";
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
    description = "@vlang language server, for all your editing needs like go-to-definition, code completion, type hints, and more";
    homepage = "https://github.com/vlang/v-analyzer";
    changelog = "https://github.com/vlang/v-analyzer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cilki ];
    platforms = lib.platforms.unix;
    mainProgram = "v-analyzer";
  };
})
