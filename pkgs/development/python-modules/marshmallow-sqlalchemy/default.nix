{ lib, buildPythonPackage, fetchPypi,
  marshmallow, sqlalchemy
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.16.2";

  meta = {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow ";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "755e6e930c1ffe3430f62091085f0a51e0817b240986d931014f03b3556fff34";
  };

  propagatedBuildInputs = [ marshmallow sqlalchemy ];

  doCheck = false;
}
