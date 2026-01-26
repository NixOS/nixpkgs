{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcg";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "vcglib";
    tag = finalAttrs.version;
    hash = "sha256-OZnqFnHGXC9fS7JCLTiHNCeA//JBAZGLB5SP/rGzaA8=";
  };

  patches = [
    # CMake: install lib and exports
    # ref. https://github.com/cnr-isti-vclab/vcglib/pull/248
    # merged upstream
    (fetchpatch {
      name = "cmake-install-lib-and-exports.patch";
      url = "https://github.com/cnr-isti-vclab/vcglib/commit/4a8dd8d6e54890aee76917d27aabfa7031cbc68d.patch";
      hash = "sha256-b3qsmLu+4VSs943VS3C4gdG/PDR2mhr9/dDTmkep8zo=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
  ];

  cmakeFlags = [
    (lib.cmakeBool "VCG_ALLOW_BUNDLED_EIGEN" false)
    (lib.cmakeBool "VCG_BUILD_EXAMPLES" false)
  ];

  meta = {
    homepage = "https://vcg.isti.cnr.it/vcglib/install.html";
    description = "C++ library for manipulation, processing and displaying with OpenGL of triangle and tetrahedral meshes";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
