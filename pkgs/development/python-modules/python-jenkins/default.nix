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
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b11f7c1dffc48579afefa8a310cba5b1c98785b9132892ff8cf5312f32ebc90";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ pbr pyyaml setuptools six multi_key_dict requests ];

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
