{ stdenv
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02wbyjixvzd6l1mljpm1ci7x835zhk3nqxgy7kvbi4jimvairs9q";
  };

  buildInputs = [
   cython
  ];

  # No test
  doCheck = false;

  checkPhase = ''
    pytest murmurhash
  '';

  meta = with stdenv.lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = https://github.com/explosion/murmurhash;
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu sdll ];
  };
}
