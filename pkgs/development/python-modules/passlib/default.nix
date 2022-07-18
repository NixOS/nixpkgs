{ lib
, buildPythonPackage
, fetchPypi
, argon2-cffi
, bcrypt
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04";
  };

  passthru.optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
    totp = [ cryptography ];
  };

  checkInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.argon2
    ++ passthru.optional-dependencies.bcrypt
    ++ passthru.optional-dependencies.totp;

  meta = with lib; {
    description = "A password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = licenses.bsdOriginal;
  };
}
