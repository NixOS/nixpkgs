{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
, cython
, pytestCheckHook
, rapidfuzz
, rapidfuzz-cpp
, scikit-build
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.19.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-2/m9vn3yHDt5sjE/hY3s3gBCkZnehbk25+VReLo2jn8=";
  };

  nativeBuildInputs = [
    cmake
    cython
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
  ];

  propagatedBuildInputs = [
    rapidfuzz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "Levenshtein"
  ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
