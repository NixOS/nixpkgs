{
  lib,
  stdenv,
  fetchFromGitHub,
  hostPlatform,
  cmake,
  pkg-config,
  ispc,
  vapoursynth,
  zimg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vs-nlm-ispc";
  version = "2";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-ispc";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-lP/6a83Sy+R4umt2GiZnB/to/x6jjGOChgUFQZQUwz4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ispc
  ];

  buildInputs = [
    vapoursynth
    zimg
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_ISPC_INSTRUCTION_SETS" (
      if hostPlatform.isx86_64 then "sse2-i32x4;avx1-i32x4;avx2-i32x8" else "neon-i32x4"
    ))
    (lib.cmakeFeature "CMAKE_ISPC_FLAGS" "--opt=fast-math")
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${VS_LIBDIR}" "lib"
  '';

  meta = {
    description = "Plugin for VapourSynth: vs-nlm-ispc";
    homepage = "https://github.com/AmusementClub/vs-nlm-ispc";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
})
