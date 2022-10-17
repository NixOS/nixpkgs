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
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bHTHAHiAm/3doXvpZIPEHQbXF5NLB8q3khAR2BdYs1c=";
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
