{ lib
, buildPythonPackage
, fetchPypi
, dateutil
, pep8
, pillow
, pyproj
, pytz
, pytest
, pytestcov
, requests
, tox
}:

buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m05225g1sqd2i8r2riaan33953hfni9wjq7n225snhl7klsb5gc";
  };

  buildInputs = [ dateutil pep8 pillow pyproj pytz requests tox ];
  checkInputs = [ pytest pytestcov ];

  # test runner finds no tests and fails build with no displayed error.
  doCheck = false;

  meta = with lib; {
    description = "Client programming with Open Geospatial Consortium (OGC) web service.";
    license = licenses.bsd3;
    homepage = http://geopython.github.io/OWSLib;
  };
}
