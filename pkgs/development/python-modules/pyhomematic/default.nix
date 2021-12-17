{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.76";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea2496c920451ded4561e3758c8f77157fc00c40d1f75d8163e399fd3e0d795a";
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
