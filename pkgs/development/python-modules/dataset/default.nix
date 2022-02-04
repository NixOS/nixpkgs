{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, alembic
, banal
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TDZ6fAqFxOdI79o07uMAw/zD8HbHXDKQt0mnoFM1yEc=";
  };

  propagatedBuildInputs = [
    sqlalchemy alembic banal
  ];

  # checks attempt to import nonexistent module 'test.test' and fail
  doCheck = false;

  pythonImportsCheck = [
    "dataset"
  ];

  meta = with lib; {
    description = "Toolkit for Python-based database access";
    homepage = "https://dataset.readthedocs.io";
    license = licenses.mit;
    maintainers = [ maintainers.xfnw ];
  };
}
