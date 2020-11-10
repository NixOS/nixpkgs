{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02jbad9vbnjx8bmfvxg77z18nymrry6li8hy9pwi0yiyvwbnycyr";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ sqlalchemy shapely ];

  # https://github.com/geoalchemy/geoalchemy2/blob/e05a676350b11f0e73609379dae5625c5de2e868/TEST.rst
  doCheck = false;

  meta = with stdenv.lib; {
    homepage =  "http://geoalchemy.org/";
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
