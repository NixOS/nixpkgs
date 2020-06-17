{ stdenv
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
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jrnci1pw9yv7j1a9b2q6c955l3gb8fv1q4d0id6s7bwr5l39mv1";
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
  
  meta = with stdenv.lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = "https://github.com/explosion/preshed";
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
