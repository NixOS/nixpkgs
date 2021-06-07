{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, sqlalchemy
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.24.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee3ead3b83de6608c6850ff60515691b0dc556ca226680f8a82b9f785cdb71b1";
  };

  propagatedBuildInputs = [
    marshmallow
    sqlalchemy
  ];

  checkInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow ";
    license = licenses.mit;
  };

}
