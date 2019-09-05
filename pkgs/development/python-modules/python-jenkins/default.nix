{ lib
, buildPythonPackage
, fetchPypi
, mock
, pbr
, pyyaml
, six
, multi_key_dict
, testscenarios
, requests
, unittest2
, requests-mock
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "145w5vri4lygz0pqjclibdw9h72vp86332pszsd5fj7wvz0zf48b";
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
