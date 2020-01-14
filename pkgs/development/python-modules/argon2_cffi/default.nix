{ cffi
, six
, enum34
, hypothesis
, pytest
, wheel
, buildPythonPackage
, fetchPypi
, isPy3k
, lib
}:

buildPythonPackage rec {
  pname = "argon2_cffi";
  version = "19.2.0";

  src = fetchPypi {
    pname = "argon2-cffi";
    inherit version;
    sha256 = "ffaa623eea77b497ffbdd1a51e941b33d3bf552c60f14dbee274c4070677bda3";
  };

  propagatedBuildInputs = [ cffi six ] ++ lib.optional (!isPy3k) enum34;
  checkInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = https://argon2-cffi.readthedocs.io/;
    license     = licenses.mit;
  };
}
