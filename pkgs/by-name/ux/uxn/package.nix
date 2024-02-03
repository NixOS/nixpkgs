{ lib
, stdenv
, fetchFromSourcehut
, SDL2
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "unstable-2023-09-29";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "c71842aa8472f26c0ea7fbf92624659313c038ba";
    hash = "sha256-Lo1AkK81Hv8A0jBfpR4lxlBJcWkh9LttURiXVoibKSs=";
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
      --replace "-L/usr/local/lib " "" \
      --replace "\$(brew --prefix)/lib/libSDL2.a " ""
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
    description = "An assembler and emulator for the Uxn stack machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "uxnemu";
    inherit (SDL2.meta) platforms;
    # ofborg complains about an error trying to link inexistent SDL2 library
    # For full logs, run:
    # 'nix log /nix/store/bmyhh0lpifl9swvkpflqldv43vcrgci1-uxn-unstable-2023-08-10.drv'.
    broken = stdenv.isDarwin;
  };
})
