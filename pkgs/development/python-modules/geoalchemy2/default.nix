{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
, setuptools-scm
, pytest
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0e56d4a945bdc0f8fa9edd50ecc912889ea68e0e3558a19160dcb0d5b1b65fc";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ sqlalchemy shapely ];

  # https://github.com/geoalchemy/geoalchemy2/blob/e05a676350b11f0e73609379dae5625c5de2e868/TEST.rst
  doCheck = false;

  meta = with lib; {
    homepage =  "http://geoalchemy.org/";
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
