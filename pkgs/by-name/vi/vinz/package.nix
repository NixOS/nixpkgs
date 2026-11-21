{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "vinz";
  version = "2026-04-25";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vinz-ux";
    repo = "VinZ";
    rev = "aa48ba85903bc027072aa82d1cf13a4cd4bee83c";
    hash = "sha256-CKZvxWBlMx7Ubcs5XqoIJ3+4A3N++Q0UTXDjNHnAoNU=";
  };

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp vinz $out/bin/vinz
    ln -s $out/bin/vinz $out/bin/vz

    runHook postInstall
  '';

  meta = {
    description = "A highly interactive, true-color, 3D raymarching, procedural graphics engine for the terminal";
    homepage = "https://github.com/vinz-ux/VinZ";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lords1nister1 ];
    platforms = lib.platforms.unix;
    mainProgram = "vinz";
  };
}
