{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Minimal,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visusort";
  version = "0-unstable-2025-09-02";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crypticsaiyan";
    repo = "visusort";
    rev = "ef6355879aa2d81dee5a5d3c2d5dedd37ba95a36";
    hash = "sha256-gylaICSdbinyrVdUhbxdkGZEAVNVmXWVpuOp0uFd3ow=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postPatch = ''
    substituteInPlace visusort.py \
      --replace-fail './main' '${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}-cli'
  '';

  buildPhase = ''
    runHook preBuild

    $CXX $(find . -name "*.cpp") \
      --output=${finalAttrs.meta.mainProgram}-cli \
      --optimize=3

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.meta.mainProgram}-cli --target-directory=$out/bin
    install -Dm644 visusort.py --target-directory=$out/lib

    makeWrapper ${lib.getExe python3Minimal} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags $out/lib/visusort.py

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "TUI and CLI tool to visualize sorting algorithms";
    homepage = "https://github.com/crypticsaiyan/visusort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "visusort";
    platforms = lib.platforms.unix;
  };
})
