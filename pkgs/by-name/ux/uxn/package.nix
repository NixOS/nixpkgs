{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "1.0-unstable-2025-06-16";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "97bcf2108b1d87ad80f4344bfc1aca447abe8108";
    hash = "sha256-G+0oeqrCMHtG0V5DZafZVx1rKIncH6rDgBealGInMho=";
  };

  outputs = [
    "out"
    "projects"
  ];

  nativeBuildInputs = [
    SDL2
  ];

  buildInputs = [
    SDL2
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace "-L/usr/local/lib " "" \
      --replace "$(brew --prefix)/lib/libSDL2.a " "" \
      --replace "--static-libs" "--libs" \
      --replace " | sed -e 's/-lSDL2 //'" ""
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

  # ./build.sh --install is meant to install in $HOME, therefore not useful for
  # package maintainers
  installPhase = ''
    runHook preInstall

    install -d $out/bin/
    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    install -d $projects/share/uxn/
    cp -r projects $projects/share/uxn/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "Assembler and emulator for the Uxn stack machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "uxnemu";
    inherit (SDL2.meta) platforms;
  };
})
