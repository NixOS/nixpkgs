{ lib
, buildPythonPackage
, fetchPypi
, mock
, pbr
, pyyaml
, setuptools
, six
, multi_key_dict
, testscenarios
, requests
, unittest2
, requests-mock
}:

buildPythonPackage rec {
  pname = "python-jenkins";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01jid5s09lr3kayr2h1z9n8h9nhyw3jxv9c4b5hrlxijknkqzvfy";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pbr pyyaml setuptools six multi_key_dict requests ];

  checkInputs = [ unittest2 testscenarios requests-mock ];
  checkPhase = ''
    unit2
  '';

  meta = with lib; {
    description = "Python bindings for the remote Jenkins API";
    homepage = "https://pypi.python.org/pypi/python-jenkins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
