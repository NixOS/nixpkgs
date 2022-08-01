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
  version = "0.19.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-4Oc1n/ZgLdq57ZeyZHzTQOjar9Ligeb4yqKeT0s5dHY=";
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
