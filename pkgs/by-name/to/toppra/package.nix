{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  python3Packages,

  # buildInputs
  eigen,
  glpk,
  msgpack-cxx,
  pinocchio,
  qpoases,

  # checkInputs
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toppra";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "hungpham2511";
    repo = "toppra";
    tag = finalAttrs.version;
    hash = "sha256-bCCKEDzJclKbX7w27Icgtasxue04+NVvn3PlzaZvvWs=";
  };

  sourceRoot = "source/cpp";

  # fix ld: cannot open output file
  # /build/source/toppra/toppra/cpp/toppra_int.cpython-313-x86_64-linux-gnu.so:
  # No such file or directory
  postPatch = ''
    substituteInPlace bindings/CMakeLists.txt --replace-fail \
      "LIBRARY_OUTPUT_DIRECTORY $""{TOPPRA_PYTHON_SOURCE_DIR}" \
      "LIBRARY_OUTPUT_DIRECTORY $""{CMAKE_CURRENT_BINARY_DIR}"
  '';

  nativeBuildInputs = [
    cmake
    python3Packages.pybind11
  ];

  buildInputs = [
    python3Packages.boost
    eigen
    glpk
    msgpack-cxx
    pinocchio
    qpoases
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO" true)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO_PYTHON" true)
    (lib.cmakeBool "BUILD_WITH_qpOASES" true)
    (lib.cmakeBool "BUILD_WITH_GLPK" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "OPT_MSGPACK" true)
    (lib.cmakeBool "PYTHON_BINDINGS" true)
    (lib.cmakeFeature "PYTHON_VERSION" (lib.versions.majorMinor python3Packages.python.version))
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Robotic motion planning library";
    homepage = "https://github.com/hungpham2511/toppra";
    changelog = "https://github.com/hungpham2511/toppra/blob/${finalAttrs.src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
