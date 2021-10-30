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
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6d3dba39ed5059aaf99767017b9568c75b2d0780c3481e204b1daecde00360e";
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
