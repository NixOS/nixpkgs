{ lib
, alembic
, banal
, buildPythonPackage
, fetchPypi
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TDZ6fAqFxOdI79o07uMAw/zD8HbHXDKQt0mnoFM1yEc=";
  };

  propagatedBuildInputs = [
    alembic
    banal
    sqlalchemy
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
    maintainers = with maintainers; [ xfnw ];
  };
}
