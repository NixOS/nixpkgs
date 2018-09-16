{ lib, buildPythonPackage, fetchPypi, requests, geojson }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed175873823a2fedb48e453505c974ca39f3f75006ef1af54fdbcf72e6796849";
  };

  propagatedBuildInputs = [ requests geojson ];

  # This may actually break the package.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "requests>=2.18.2,<2.19" "requests"  \
      --replace "geojson>=2.3.0,<2.4" "geojson<2.5,>=2.3.0"
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper around the OpenWeatherMap web API";
    homepage = https://pyowm.readthedocs.io/;
    license = licenses.mit;
  };
}
