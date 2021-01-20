{ lib, stdenv
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "422084ac1fe994cb7c893689c600923dee4e2c3fc74e832f7d9a8d6fdcc362d5";
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
    maintainers = with maintainers; [ aborsu sdll ];
  };
}
