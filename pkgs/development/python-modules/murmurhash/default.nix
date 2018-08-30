{ stdenv
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16id8jppw8r54wisrlaaiprcszzb7d7lbpnskqn38s8i7vnkf4b5";
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
