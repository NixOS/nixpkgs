{ lib
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i7A6rYQoN6ZLDB0u0itQ66hfn6UUdsi8CnfDZql58fM=";
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
