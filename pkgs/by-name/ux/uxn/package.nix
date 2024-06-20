{ lib
, stdenv
, fetchFromSourcehut
, SDL2
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "1.0-unstable-2024-06-14";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "07112d8f264ecb423a9cadf403c224a8a0eac3cb";
    hash = "sha256-AMqMeiJsRsoZKOEZVLojgeaaUiyulacwiNFIKUCwhFk=";
  };

  outputs = [ "out" "projects" ];

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
    broken = stdenv.isDarwin;
  };
})
