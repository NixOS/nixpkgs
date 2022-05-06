{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
, cython
, pytestCheckHook
, rapidfuzz
, scikit-build
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.18.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "v${version}";
    # https://github.com/maxbachmann/Levenshtein/issues/22
    fetchSubmodules = true;
    sha256 = "sha256-WREYdD5MFOpCzH4BSceRpzQZdpi3Xxxn0DpMvDsNlGo=";
  };

  nativeBuildInputs = [
    cmake
    cython
    scikit-build
  ];

  dontUseCmakeConfigure = true;

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
