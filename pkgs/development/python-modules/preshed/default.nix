{ lib, stdenv
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
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13a779205d55ce323976ac06df597f9ec2d6f0563ebcf5652176cf4520c7d540";
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
    maintainers = with maintainers; [ sdll ];
    };
}
