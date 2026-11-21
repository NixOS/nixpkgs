{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "uxn2";
  version = "1.0-unstable-2026-09-16";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn2";
    rev = "4ec66b5df3e9e31968f795b6bba17ec42068e6c6";
    hash = "sha256-Ukm+QTaKFc5b2w4S3837AN1bZtorx7zJlDVfXQaH/ow=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    SDL2
  ];

  buildInputs = [
    SDL2
  ];

  strictDeps = true;

  buildFlags = [ "bin/uxn2" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/uxn2 $out/bin/uxn2
    install -Dm644 doc/man/uxntal.7 $man/share/man/man7/uxntal.7
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://git.sr.ht/~rabbits/uxn2";
    description = "Varvara Ordinator, written in C89(SDL2)";
    longDescription = ''
      A graphical emulator for the Varvara Computer, written in C99(SDL2).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vkluna ];
    mainProgram = "uxn2";
    inherit (SDL2.meta) platforms;
  };
})
