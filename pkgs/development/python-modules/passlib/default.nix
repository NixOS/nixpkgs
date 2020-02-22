{ buildPythonPackage
, fetchPypi
, nose
, bcrypt
, argon2_cffi
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d666cef936198bc2ab47ee9b0410c94adf2ba798e5a84bf220be079ae7ab6a8";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ bcrypt argon2_cffi ];

  meta = {
    description = "A password hashing library for Python";
    homepage    = https://code.google.com/p/passlib/;
  };
}
