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
, stdenv
}:

buildPythonPackage rec {
  pname = "argon2_cffi";
  version = "21.1.0";

  src = fetchPypi {
    pname = "argon2-cffi";
    inherit version;
    sha256 = "sha256-9xC2EQPRofaSyj7L0Tc+KKpeVFrGJboGf/L+yhsruHA=";
  };

  propagatedBuildInputs = [ cffi six ] ++ lib.optional (!isPy3k) enum34;

  propagatedNativeBuildInputs = [ cffi ];

  ARGON2_CFFI_USE_SSE2 = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) "0";

  checkInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = "https://argon2-cffi.readthedocs.io/";
    license     = licenses.mit;
  };
}
