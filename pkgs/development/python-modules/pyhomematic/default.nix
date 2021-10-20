{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.75";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "36b76d7269273888f61db085f3fb47e5516c4d1bd15b2b39a54305cdb6a9a8b8";
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
