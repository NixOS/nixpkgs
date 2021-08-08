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
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c32023bc2fb8fbb136f00a0e9c2feba21f3e1040af0f619c888661f6ee72dd28";
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
