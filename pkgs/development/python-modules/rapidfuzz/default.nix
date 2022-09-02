{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython_3
, ninja
, rapidfuzz-capi
, scikit-build
, setuptools
, jarowinkler
, numpy
, hypothesis
, jarowinkler-cpp
, pandas
, pytestCheckHook
, rapidfuzz-cpp
, taskflow
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "2.6.0";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "refs/tags/v${version}";
    hash = "sha256-EplQodBTdZCqhM+6nCovpnqDJ6zvu+jG5muVMLIxdKI=";
  };

  nativeBuildInputs = [
    cmake
    cython_3
    ninja
    rapidfuzz-capi
    scikit-build
    setuptools
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    jarowinkler-cpp
    rapidfuzz-cpp
    taskflow
  ];

  preBuild = ''
    export RAPIDFUZZ_BUILD_EXTENSION=1
  '';

  propagatedBuildInputs = [
    jarowinkler
    numpy
  ];

  checkInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rapidfuzz.fuzz"
    "rapidfuzz.string_metric"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = with lib; {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
