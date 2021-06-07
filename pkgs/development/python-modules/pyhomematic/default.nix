{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.73";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KaeheCIJgAqC68rgE71b1sSatSH25phGk662fnuOOsk=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "pyhomematic" ];

  meta = with lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = "https://github.com/danielperna84/pyhomematic";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
