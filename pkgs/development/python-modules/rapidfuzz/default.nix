{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython_3
, ninja
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
  version = "2.13.2";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "refs/tags/v${version}";
    hash = "sha256-a83Vww9dEh0nNylnZwCm6PJYmfKvw5RnMLerfKfN1dY=";
  };

  nativeBuildInputs = [
    cmake
    cython_3
    ninja
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
