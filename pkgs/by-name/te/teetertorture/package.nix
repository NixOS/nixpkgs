{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_image,
  SDL_mixer,
}:

stdenv.mkDerivation rec {
  pname = "teeter-torture";
  version = "2005-10-18";
  src = fetchurl {
    url = "ftp://ftp.tuxpaint.org/unix/x/teetertorture/source/teetertorture-${version}.tar.gz";
    sha256 = "175gdbkx3m82icyzvwpyzs4v2fd69c695k5n8ca0lnjv81wnw2hr";
  };

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
  ];

  configurePhase = ''
    runHook preConfigure

    sed -i s,data/,$out/share/teetertorture/, src/teetertorture.c

    runHook postConfigure
  '';

  patchPhase = ''
    sed -i '/free(home)/d' src/teetertorture.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/teetertorture
    cp teetertorture $out/bin
    cp -R data/* $out/share/teetertorture
  '';

  meta = {
    homepage = "http://www.newbreedsoftware.com/teetertorture/";
    description = "Simple shooting game with your cannon is sitting atop a teeter totter";
    license = lib.licenses.gpl2Plus;
    inherit (SDL.meta) platforms;
    mainProgram = "teetertorture";
  };
}
