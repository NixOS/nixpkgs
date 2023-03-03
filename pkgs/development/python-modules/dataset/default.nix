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
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fNvJBdZjtYKvhGzwULfP2iDNUrqhxiwRlhlFrHfmGdU=";
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
