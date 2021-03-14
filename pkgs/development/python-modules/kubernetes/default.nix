{ lib, buildPythonPackage, fetchPypi, pythonAtLeast
, ipaddress, websocket_client, urllib3, pyyaml, requests_oauthlib, python-dateutil, google-auth, adal
, isort, pytestCheckHook, coverage, mock, sphinx, autopep8, pep8, codecov, recommonmark, nose }:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "12.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec52ea01d52e2ec3da255992f7e859f3a76f2bdb51cf65ba8cd71dfc309d8daa";
  };

  # prePatch = ''
  #   sed -e 's/sphinx>=1.2.1,!=1.3b1,<1.4 # BSD/sphinx/' -i test-requirements.txt

  #   # This is used to randomize tests, which is not reproducible. Drop it.
  #   sed -e '/randomize/d' -i test-requirements.txt
  # ''
  # # This is a python2 and python3.2 only requiremet since it is a backport of a python-3.3 api.
  # + lib.optionalString (pythonAtLeast "3.3")
  # "sed -e '/ipaddress/d' -i requirements.txt";

  propagatedBuildInputs = [ ipaddress websocket_client urllib3 pyyaml requests_oauthlib python-dateutil google-auth adal ];
  checkInputs = [ isort coverage pytestCheckHook mock sphinx autopep8 pep8 codecov recommonmark nose ];

  disabledTestPaths = [
    "kubernetes/dynamic/test_client.py"
  ];

  meta = with lib; {
    description = "Kubernetes python client";
    homepage = "https://github.com/kubernetes-client/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
