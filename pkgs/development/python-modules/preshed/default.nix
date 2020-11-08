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
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ad47d5d2688fabc66850f32c7b6d3b4a97e6b653726309fe09603edd6fceb23";
  };

  requiredPythonModules = [
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
