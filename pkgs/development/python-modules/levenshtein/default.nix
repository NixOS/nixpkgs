{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, rapidfuzz
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.18.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "v${version}";
    sha256 = "sha256-3p9LM4tv45bqeTsuyngivqfd5uml7uqGB2ICKqPa0qY=";
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
