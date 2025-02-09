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
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d9NiEY9nqMu0hI29MKs2K5+nz+vb+vQmycUAyziWmpk=";
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
    # SQLAlchemy >= 2.0.0 is unsupported
    # https://github.com/pudo/dataset/issues/411
    broken = true;
  };
}
