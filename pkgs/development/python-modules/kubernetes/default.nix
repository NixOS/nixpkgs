{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast,
  ipaddress, websocket_client, urllib3, pyyaml, requests_oauthlib, python-dateutil, google_auth, adal,
  isort, pytest, coverage, mock, sphinx, autopep8, pep8, codecov, recommonmark, nose }:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "9.0.0";

  prePatch = ''
    sed -e 's/sphinx>=1.2.1,!=1.3b1,<1.4 # BSD/sphinx/' -i test-requirements.txt

    # This is used to randomize tests, which is not reproducible. Drop it.
    sed -e '/randomize/d' -i test-requirements.txt
  ''
  # This is a python2 and python3.2 only requiremet since it is a backport of a python-3.3 api.
  + (if (pythonAtLeast "3.3")  then ''
    sed -e '/ipaddress/d' -i requirements.txt
  '' else "");

  checkPhase = ''
    py.test
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gz3sk4s0gx68xpxjwzp9n2shlxfa9d5j4h7cvmglim9bgasxc58";
  };

  checkInputs = [ isort coverage pytest mock sphinx autopep8 pep8 codecov recommonmark nose ];
  propagatedBuildInputs = [ ipaddress websocket_client urllib3 pyyaml requests_oauthlib python-dateutil google_auth adal ];

  meta = with stdenv.lib; {
    description = "Kubernetes python client";
    homepage = https://github.com/kubernetes-client/python;
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
