{ lib
, buildPythonPackage
, fetchPypi
, requests
, testfixtures
, mock
, requests-toolbelt
, betamax
, betamax-serializers
, betamax-matchers
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "2.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vgmhjddqxnz5vy70dyqvakak51fg1nk6j3xavkc83d8nzacrwfs";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    testfixtures
    mock
    betamax
    betamax-serializers
    betamax-matchers
    requests-toolbelt
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prawcore" ];

  meta = with lib; {
    description = "Low-level communication layer for PRAW";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ fab ];
  };
}
