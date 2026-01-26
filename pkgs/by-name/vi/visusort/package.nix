{
  lib,
  stdenv,
  fetchFromGitHub,
  rustpython,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visusort";
  version = "0-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "crypticsaiyan";
    repo = "visusort";
    rev = "8bb1d118037eb059a768166d7221004e8c9dd50b";
    hash = "sha256-+Sg5XM6f0k7favnSj9r0UWVszRF97ZAp0yCuSb5DRBo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace visusort.py \
      --replace-fail './main' '${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}-cli'
  '';

  buildPhase = ''
    runHook preBuild

    $CXX $(find . -name "*.cpp") \
      --output=${finalAttrs.meta.mainProgram}-cli \
      --optimize=3 \
      -s

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.meta.mainProgram}-cli --target-directory=$out/bin
    install -Dm644 visusort.py --target-directory=$out/lib

    makeWrapper ${lib.getExe rustpython} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags $out/lib/visusort.py

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI and CLI tool to visualize sorting algorithms";
    homepage = "https://github.com/crypticsaiyan/visusort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "visusort";
    platforms = lib.platforms.all;
  };
})
