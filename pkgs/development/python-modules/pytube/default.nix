{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytube";
  version = "12.0.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pytube";
    repo = "pytube";
    rev = "v${version}";
    hash = "sha256-1zoLd4J7aCR5omMpCZhlttWDu7mYyKCypH3JEB4VGXg=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/test_extract.py"
    "tests/test_query.py"
    "tests/test_streams.py"
    "tests/test_main.py"
  ];

  pythonImportsCheck = [ "pytube" ];

  meta = with lib; {
    description = "Python 3 library for downloading YouTube Videos";
    homepage = "https://github.com/nficano/pytube";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
