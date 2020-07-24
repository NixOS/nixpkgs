{ stdenv
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a646f6b07b033642b4f52ae2e45efd8b80780b3b90e8092a0cec935fbf81e2";
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

  meta = with stdenv.lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = "https://github.com/explosion/murmurhash";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu sdll ];
  };
}
