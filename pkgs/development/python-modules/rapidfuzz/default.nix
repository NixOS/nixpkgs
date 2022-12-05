{ lib
, stdenv
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
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    export CMAKE_ARGS="-DCMAKE_CXX_COMPILER_AR=$AR -DCMAKE_CXX_COMPILER_RANLIB=$RANLIB"
  '';

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto"  # work around https://github.com/NixOS/nixpkgs/issues/19098
  ];

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
