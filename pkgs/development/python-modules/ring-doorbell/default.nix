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
  version = "0.7.2";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    sha256 = "0a7e82abf27086843eb39c0279f5dfccea6751ff848560e67154ca6fbfa4ef2b";
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
