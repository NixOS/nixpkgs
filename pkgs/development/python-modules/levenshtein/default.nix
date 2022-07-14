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
  version = "0.19.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-tedoSeCwMWHwPlZ8qvzIMjVj5W9qJVoLAsT35hQBc/g=";
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
