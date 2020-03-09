{ lib, buildPythonPackage, fetchPypi,
  marshmallow, sqlalchemy
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.21.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow ";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "93fd8fad2b33d92a1ae58328eeb0f39ed174858d82f9e7084a174df7b41fd3a4";
  };

  propagatedBuildInputs = [ marshmallow sqlalchemy ];

  doCheck = false;
}
