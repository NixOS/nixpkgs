{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, tqdm
, nose
, vcrpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jxaO8nCR5jhXCPjhjVLKaGeQp9JF3ECQ1+j3TOJKawg=";
  };

  propagatedBuildInputs = [
    requests
    tqdm
  ];

  checkInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "habanero"
  ];

  # almost the entirety of the test suite makes network calls
  pytestFlagsArray = [
    "test/test-filters.py"
  ];

  meta = with lib; {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ nico202 ];
  };
}
