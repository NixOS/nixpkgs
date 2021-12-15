{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, rapidfuzz
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "v${version}";
    sha256 = "agshUVkkqogj4FbonFd/rrGisMOomS62NND66YKZvjg=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "rapidfuzz >= 1.8.2, < 1.9" "rapidfuzz"
  '';

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
