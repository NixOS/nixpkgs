{ lib
, buildPythonPackage
, fetchPypi
, nose
, bcrypt
, argon2_cffi
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ bcrypt argon2_cffi ];
  propagatedNativeBuildInputs = [ argon2_cffi ];

  meta = with lib; {
    description = "A password hashing library for Python";
    homepage = "https://foss.heptapod.net/python-libs/passlib";
    license = licenses.bsdOriginal;
  };
}
