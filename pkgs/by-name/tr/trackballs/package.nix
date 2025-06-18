{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_ttf,
  gettext,
  zlib,
  SDL2_mixer,
  SDL2_image,
  guile,
  libGLU,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trackballs";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "trackballs";
    repo = "trackballs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JKSiNe5mu8rRztUhduGFY6IsSMx6VyBqKcGO5EssI+8=";
  };

  postPatch = ''
    substituteInPlace src/glHelp.h --replace-fail _TTF_Font TTF_Font
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    SDL2
    SDL2_ttf
    SDL2_mixer
    SDL2_image
    guile
    gettext
    libGLU
    libGL
  ];

  meta = {
    homepage = "https://trackballs.github.io/";
    description = "3D Marble Madness clone";
    mainProgram = "trackballs";
    platforms = lib.platforms.linux;
    # Music is licensed under Ethymonics Free Music License.
    license = lib.licenses.gpl2Plus;
  };
})
