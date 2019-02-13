{ lib
, buildPythonPackage
, fetchPypi
, python
, mock
, pbr
, pyyaml
, six
, multi_key_dict
, testtools
, testscenarios
, testrepository
, kerberos
, requests
, unittest2
, requests-mock
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h14hfcwichmppbgxf1k8njw29hchpav1kj574b4lly3j0n2vnag";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pbr pyyaml six multi_key_dict requests ];

  checkInputs = [ unittest2 testscenarios requests-mock ];
  checkPhase = ''
    unit2
  '';

  meta = with lib; {
    description = "Python bindings for the remote Jenkins API";
    homepage = https://pypi.python.org/pypi/python-jenkins;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };

}
