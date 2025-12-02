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
  version = "3.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    tag = "v${version}";
    hash = "sha256-p+Z2c+PBNdjfaRjZErWwWgihzuddV14PgTHE3NVNHs8=";
  };

  patches = [
    # https://github.com/rapidfuzz/RapidFuzz/pull/463
    (fetchpatch {
      name = "support-taskflow-3.11.0.patch";
      url = "https://github.com/rapidfuzz/RapidFuzz/commit/0ef2a4980c41b852283e6db7a747a1632307c75e.patch";
      hash = "sha256-xb+J3PXwD51lZqIJcTzPJWrT/oqrIXxh1cLp91DhIPg=";
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
