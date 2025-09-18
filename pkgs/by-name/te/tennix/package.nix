{
  lib,
  stdenv,
  fetchgit,
  which,
  SDL2,
  SDL2_gfx,
  SDL2_mixer,
  SDL2_image,
  SDL2_ttf,
  SDL2_net,
  python3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tennix";
  version = "1.3.4";

  src = fetchgit {
    url = "git://repo.or.cz/tennix.git";
    tag = "tennix-${finalAttrs.version}";
    hash = "sha256-siGfnpZPMYMTgYzaPVhNXEuA/OSWmEl891cLhvgGr7o=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [
    python3
    SDL2
    SDL2_gfx
    SDL2_mixer
    SDL2_image
    SDL2_ttf
    SDL2_net
  ];

  configurePhase = ''
    runHook preConfigure

    ./configure --prefix $out

    runHook postConfigure
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "tennix-"; };

  meta = {
    homepage = "https://icculus.org/tennix/";
    description = "Classic Championship Tour 2011";
    mainProgram = "tennix";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
