{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  cython,
  ninja,
  scikit-build-core,
  numpy,
  hypothesis,
  pandas,
  pytestCheckHook,
  rapidfuzz-cpp,
  taskflow,
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    tag = "v${version}";
    hash = "sha256-vwAqlTq4HIbmCL1HsHcgfVWETImxdqTsnenmX2RGXw8=";
  };

  patches = [
    # https://github.com/rapidfuzz/RapidFuzz/pull/446
    (fetchpatch {
      name = "support-taskflow-3.10.0.patch";
      url = "https://github.com/rapidfuzz/RapidFuzz/commit/bba3281cc61ecc4ab4affe5d2d50389a4f6d7556.patch";
      hash = "sha256-kAS6xsPY7eUTfKO+EAOW8bktY4cApvLEpRMciJEsPgk=";
    })
  ];

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
    taskflow
  ];

  env.RAPIDFUZZ_BUILD_EXTENSION = 1;

  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    export CMAKE_ARGS="-DCMAKE_CXX_COMPILER_AR=$AR -DCMAKE_CXX_COMPILER_RANLIB=$RANLIB"
  '';

  optional-dependencies = {
    all = [ numpy ];
  };

  preCheck = ''
    export RAPIDFUZZ_IMPLEMENTATION=cpp
  '';

  nativeCheckInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # segfaults
    "test_cdist"
  ];

  pythonImportsCheck = [
    "rapidfuzz.distance"
    "rapidfuzz.fuzz"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
