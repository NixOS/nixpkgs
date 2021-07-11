{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, alembic
, banal
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q7gvs5dnhv2hah784gx2kqxzna20apphbc9k5j9vmxvn4k34ghc";
  };

  propagatedBuildInputs = [
    sqlalchemy alembic banal
  ];

  doCheck = false;

  meta = with lib; {
    description = "Toolkit for Python-based database access";
    homepage = "https://dataset.readthedocs.io";
    license = licenses.mit;
    maintainers = [ maintainers.xfnw ];
  };
}
