{ buildPythonPackage
, fetchPypi
, nose
, bcrypt
, argon2_cffi
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.1";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ bcrypt argon2_cffi ];

  meta = {
    description = "A password hashing library for Python";
    homepage    = https://code.google.com/p/passlib/;
  };
}
