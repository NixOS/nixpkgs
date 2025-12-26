{
  stdenv,
  fetchFromGitHub,
  lib,
  vlang,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "0.0.6-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v-analyzer";
    rev = "5f6c9c414f6e1ca3b991830c2d32b4cb83bef383";
    fetchSubmodules = true;
    hash = "sha256-CnwTLaPlqJ7gBOPqbtyieRtwVJ1Em7xIQoEztmg5At0=";
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
