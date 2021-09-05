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
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56f969cf4ad6629ebcde73e807f7dac0a9375c79991b4f93efab191f37737a00";
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
