{ lib, buildPythonPackage, fetchPypi, pythonAtLeast,
  ipaddress, websocket-client, urllib3, pyyaml, requests_oauthlib, python-dateutil, google-auth, adal,
  isort, pytest, coverage, mock, sphinx, autopep8, pep8, codecov, recommonmark, nose }:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "18.20.0";

  prePatch = ''
    sed -e 's/sphinx>=1.2.1,!=1.3b1,<1.4 # BSD/sphinx/' -i test-requirements.txt

    # This is used to randomize tests, which is not reproducible. Drop it.
    sed -e '/randomize/d' -i test-requirements.txt
  ''
  # This is a python2 and python3.2 only requiremet since it is a backport of a python-3.3 api.
  + (if (pythonAtLeast "3.3")  then ''
    sed -e '/ipaddress/d' -i requirements.txt
  '' else "");

  doCheck = pythonAtLeast "3";
  checkPhase = ''
    py.test --ignore=kubernetes/dynamic/test_client.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c72d00e7883375bd39ae99758425f5e6cb86388417cf7cc84305c211b2192cf";
  };

  checkInputs = [ isort coverage pytest mock sphinx autopep8 pep8 codecov recommonmark nose ];
  propagatedBuildInputs = [ ipaddress websocket-client urllib3 pyyaml requests_oauthlib python-dateutil google-auth adal ];

  meta = with lib; {
    description = "Kubernetes python client";
    homepage = "https://github.com/kubernetes-client/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
