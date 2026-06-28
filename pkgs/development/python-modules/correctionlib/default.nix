{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  scikit-build-core,
  setuptools-scm,

  # nativeBuildInputs
  cmake,
  ninja,

  # buildInputs
  boost,
  eigen,
  zlib,

  # dependencies
  numpy,
  packaging,
  pydantic,
  rich,

  # tests
  addBinToPathHook,
  awkward,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "correctionlib";
  version = "2.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cms-nanoAOD";
    repo = "correctionlib";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jxn5AYqHPtEPE9C5Gv9s556UH6KE1liC8JDw00vMaLg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "-Wall -Wextra -Wpedantic -Werror" \
        "" \
      --replace-fail \
        "set(BUILTIN_BOOST ON)" \
        "set(BUILTIN_BOOST OFF)" \
      --replace-fail \
        "set(BUILTIN_EIGEN ON)" \
        "set(BUILTIN_EIGEN OFF)"
  '';

  build-system = [
    pybind11
    scikit-build-core
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    boost
    eigen
    zlib
  ];

  dependencies = [
    numpy
    packaging
    pydantic
    rich
  ];

  pythonImportsCheck = [ "correctionlib" ];

  nativeCheckInputs = [
    # One test requires running the produced `correctionlib` binary
    addBinToPathHook

    awkward
    pytestCheckHook
    scipy
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # AssertionError: assert 0.9518682535564676 == 0.9518682535564679
    "test_lwtnn_example"
  ];

  meta = {
    description = "Provides a well-structured JSON data format for a wide variety of ad-hoc correction factors encountered in a typical HEP analysis";
    mainProgram = "correction";
    homepage = "https://cms-nanoaod.github.io/correctionlib/";
    changelog = "https://github.com/cms-nanoAOD/correctionlib/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
