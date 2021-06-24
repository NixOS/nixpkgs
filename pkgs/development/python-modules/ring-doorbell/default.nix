{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, oauthlib
, pytestCheckHook
, pytz
, requests
, requests-mock
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.7.0";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    sha256 = "1qnx9q9rzxhh0pygl3f9bg21b5zv7csv9h1w4zngdvsphbs0yiwg";
  };

  propagatedBuildInputs = [
    oauthlib
    pytz
    requests
    requests_oauthlib
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "ring_doorbell" ];

  meta = with lib; {
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    description = "A Python library to communicate with Ring Door Bell (https://ring.com/)";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ graham33 ];
  };
}
