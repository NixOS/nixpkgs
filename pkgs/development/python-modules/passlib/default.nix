{ lib
, buildPythonPackage
, fetchPypi
, nose
, bcrypt
}:

buildPythonPackage rec {
  pname = "passlib";
  version = "1.6.5";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z27wdxs5rj5xhhqfzvzn3yg682irkxw6dcs5jj7mcf97psk8gd8";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ bcrypt ];

  meta = {
    description = "A password hashing library for Python";
    homepage    = https://code.google.com/p/passlib/;
  };
}