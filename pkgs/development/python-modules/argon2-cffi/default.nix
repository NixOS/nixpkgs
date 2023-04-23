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
, argon2-cffi-bindings
}:

buildPythonPackage rec {
  pname = "argon2-cffi";
  version = "21.3.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d384164d944190a7dd7ef22c6aa3ff197da12962bd04b17f64d4e93d934dba5b";
  };

  propagatedBuildInputs = [ cffi six argon2-cffi-bindings ]
    ++ lib.optional (!isPy3k) enum34;

  propagatedNativeBuildInputs = [
    argon2-cffi-bindings
    cffi
  ];

  ARGON2_CFFI_USE_SSE2 = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) "0";

  nativeCheckInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = "https://argon2-cffi.readthedocs.io/";
    license     = licenses.mit;
  };
}
