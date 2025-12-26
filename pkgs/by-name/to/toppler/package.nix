{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  writableTmpDirAsHomeHook,

  buildPackages,
  pkg-config,
  gettext,
  povray,
  imagemagick,
  gimp2,

  sdl2-compat,
  SDL2_mixer,
  SDL2_image,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toppler";
  version = "1.3";

  src = fetchFromGitLab {
    owner = "roever";
    repo = "toppler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ecEaELu52Nmov/BD9VzcUw6wyWeHJcsKQkEzTnaW330=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
    sdl2-compat
    SDL2_image
    libpng
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    povray
    imagemagick
    gimp2
    # GIMP needs a writable home
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    sdl2-compat
    SDL2_mixer
    zlib
  ];

  patches = [
    # Based on https://gitlab.com/roever/toppler/-/merge_requests/3
    ./gcc14.patch
  ];

  makeFlags = [
    "CXX_NATIVE=$(CXX_FOR_BUILD)"
    "PKG_CONFIG_NATIVE=$(PKG_CONFIG_FOR_BUILD)"
    "PREFIX=${placeholder "out"}"
  ];

  preBuild = ''
    # The `$` is escaped in `makeFlags` so using it for these parameters results in infinite recursion
    makeFlagsArray+=(CXX=$CXX PKG_CONFIG=$PKG_CONFIG);
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jump and run game, reimplementation of Tower Toppler/Nebulus";
    homepage = "https://gitlab.com/roever/toppler";
    license = with lib.licenses; [
      gpl2Plus
      # Makefile
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "toppler";
  };
})
