{ lib
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ywo5br0xykTYm07KNvp06oquckrfCvqi3naAw1Cyk28=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'wheel>=0.32.0,<0.33.0'" ""
  '';

  buildInputs = [
   cython
  ];

  # No test
  doCheck = false;

  checkPhase = ''
    pytest murmurhash
  '';

  meta = with lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = "https://github.com/explosion/murmurhash";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
