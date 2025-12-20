{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_ttf,
  ffmpeg,
}:

stdenv.mkDerivation rec {
  pname = "video-compare";
  version = "20251213";

  src = fetchFromGitHub {
    owner = "pixop";
    repo = "video-compare";
    tag = version;
    hash = "sha256-8O1wBDjb1iXC9mHisMAnlDOjHPrlWw69GYO+pMxC8Dg=";
  };

  postPatch = ''
    # Fix build on Darwin by using $CXX set by setup-hook
    substituteInPlace makefile \
      --replace-fail 'CXX = g++' ""
  '';

  buildInputs = [
    SDL2
    SDL2_ttf
    ffmpeg
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin video-compare

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/pixop/video-compare";
    description = "Split screen video comparison tool";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    mainProgram = "video-compare";
    platforms = lib.platforms.unix;
  };
}
