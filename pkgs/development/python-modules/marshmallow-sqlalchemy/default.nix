{ lib, buildPythonPackage, fetchPypi,
  marshmallow, sqlalchemy
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.14.2";

  meta = {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow ";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "56d66597bb9f2a240e75a641d74743d2dc13596ca2a86641aa0bc58f83bbc3e0";
  };

  propagatedBuildInputs = [ marshmallow sqlalchemy ];

  doCheck = false;
}
