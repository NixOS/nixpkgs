{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.72";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1d44103b90418d9c8cde4699a1c671d57d12469be23a45e93bfc00df28ef11b";
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
