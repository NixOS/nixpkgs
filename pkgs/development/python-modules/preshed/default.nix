{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cython
, cymem
, python
}:
buildPythonPackage rec {
  pname = "preshed";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b99ace606143a922163a7ff7ad4969b296288f5b20b9c9bda328caec3b92f71";
  };

  propagatedBuildInputs = [
   cython
   cymem
  ];
  buildInputs = [
    pytest
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = https://github.com/explosion/preshed;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
