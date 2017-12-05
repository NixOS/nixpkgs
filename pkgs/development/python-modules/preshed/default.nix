{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cython
, cymem
, python
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "preshed";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pdl4p2d32ficfh18xdkgsj6ajzdxc6mxhhf84z0wq1l8viskcx6";
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
