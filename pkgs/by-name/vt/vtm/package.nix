{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freetype,
  harfbuzz,
  lua5_4,
  lunasvg,
  plutovg,
  stb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "2026.07.30";

  src = fetchFromGitHub {
    owner = "directvt";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ff4JwJzRZKH+XM+iH3v17RkYMOwmxLlk7OzL+1Q5QHw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    freetype
    harfbuzz
    lua5_4
    lunasvg
    plutovg
    stb
  ];

  env.STB_INCLUDE_DIR = "${stb}/include/stb";

  cmakeFlags = [
    (lib.cmakeBool "FORCE_VENDORED_DEPS" false)
  ];

  meta = {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://github.com/directvt/vtm";
    license = lib.licenses.mit;
    mainProgram = "vtm";
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    platforms = lib.platforms.all;
  };
})
