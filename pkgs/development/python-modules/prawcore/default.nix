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
  version = "2.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bde42fad459c4dcfe0f22a18921ef4981ee7cd286ea1de3eb697ba91838c9123";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
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
