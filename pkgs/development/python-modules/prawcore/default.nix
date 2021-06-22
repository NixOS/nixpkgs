{ lib
, buildPythonPackage
, fetchPypi
, requests
, testfixtures
, mock
, requests_toolbelt
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
    sha256 = "08wiij1r3flpnqzdx8bf536yf7lqyhg9461aybhcykcw8nnjzr5x";
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
    requests_toolbelt
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
