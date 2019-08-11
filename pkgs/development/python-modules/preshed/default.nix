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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rd943zp4gyspajqm5qxzndxziyh51grx0zcw23w8r9r65s1rq6s";
  };

  propagatedBuildInputs = [
   cython
   cymem
  ];

  buildInputs = [
    pytest
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "wheel>=0.32.0,<0.33.0" "wheel>=0.31.0"
  '';

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
