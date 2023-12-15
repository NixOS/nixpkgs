{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.77";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00d95c21b95a17bc07586f69c976fb343a103adc0954d7b2d56c7160665625cb";
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
