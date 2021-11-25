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
  version = "0.7.1";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    sha256 = "sha256-xE3TqXdhiUf9Tzmzc48D65Y5t1ekauacsTwwSG1urz4=";
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
