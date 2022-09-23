{ lib
, buildPythonPackage
, fetchPypi
, oauthlib
, pytestCheckHook
, pythonOlder
, pytz
, requests
, requests-mock
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-Cn6Cq/JwhoQ+s5wCefXfzOpnUf+EhWDmcVTKb7+k7ys=";
  };

  propagatedBuildInputs = [
    oauthlib
    pytz
    requests
    requests-oauthlib
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "ring_doorbell"
  ];

  meta = with lib; {
    description = "Python library to communicate with Ring Door Bell";
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ graham33 ];
  };
}
