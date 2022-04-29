{ lib
, buildPythonPackage
, fetchPypi
, murmurhash
, pytest
, cython
, cymem
, python
}:
buildPythonPackage rec {
  pname = "preshed";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb3b7588a3a0f2f2f1bf3fe403361b2b031212b73a37025aea1df7215af3772a";
  };

  propagatedBuildInputs = [
    cython
    cymem
    murmurhash
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = "https://github.com/explosion/preshed";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
