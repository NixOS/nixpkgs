{
  lib,
  stdenv,
  fetchgit,
  which,
  SDL,
  SDL_mixer,
  SDL_image,
  SDL_ttf,
  SDL_net,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "tennix";
  version = "1.3.1";

  src = fetchgit {
    url = "git://repo.or.cz/tennix.git";
    tag = "tennix-${version}";
    hash = "sha256-U5+S1jEeg+7gdM1++dln6ePTqxZu2Zt0oUrH3DIlkgk=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [
    python3
    SDL
    SDL_mixer
    SDL_image
    SDL_ttf
    SDL_net
  ];

  configurePhase = ''
    runHook preConfigure

    ./configure --prefix $out

    runHook postConfigure
  '';

  meta = {
    homepage = "https://icculus.org/tennix/";
    description = "Classic Championship Tour 2011";
    mainProgram = "tennix";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
}
