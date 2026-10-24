{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freetype,
  harfbuzz,
  lua5_5,
  lunasvg,
  plutovg,
  stb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "2026.10.05";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "directvt";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SQL3fBA7/PcHFt603y3f/q0wzhD+0VynTouOuNMrCM4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    freetype
    harfbuzz
    lua5_5
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
