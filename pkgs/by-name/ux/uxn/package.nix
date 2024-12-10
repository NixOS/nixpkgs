{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "1.0-unstable-2024-10-19";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "30ac4bdcb1efed3680f746fd8290f1aeb7a6fd27";
    hash = "sha256-p+N5zOl9Gjd3C0Vx8t4B9njO1aQ8PTcik6WlsQPGKyU=";
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
      --replace "-L/usr/local/lib " ""
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "uxnemu";
    inherit (SDL2.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
