{ lib, buildPythonPackage, fetchPypi,
  marshmallow, sqlalchemy
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.24.1";

  meta = {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow ";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "d051cf013c075c43e1ee5c4b01f8fab6dd6b140dab6825be45875f674a0d289c";
  };

  propagatedBuildInputs = [ marshmallow sqlalchemy ];

  doCheck = false;
}
