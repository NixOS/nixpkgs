{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  cython,
  ninja,
  scikit-build-core,
  setuptools,
  numpy,
  hypothesis,
  pandas,
  pytestCheckHook,
  rapidfuzz-cpp,
  taskflow,
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "3.10.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "refs/tags/v${version}";
    hash = "sha256-0L8nkjgWdP/w//M69ZRxYk9If3CIEcnAl9mkJKJ4o1g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython >=3.0.11, <3.1.0" "Cython"
  '';

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

  preBuild =
    ''
      export RAPIDFUZZ_BUILD_EXTENSION=1
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
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

  meta = with lib; {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
