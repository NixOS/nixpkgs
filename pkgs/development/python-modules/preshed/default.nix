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
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Oc0qCrGtsRRSxheDHqDM6n0XEvKBLRdEc4c1mHUTETo=";
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
