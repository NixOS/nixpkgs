{ lib, buildPythonPackage, fetchPypi, pythonOlder, requests, geojson }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "3.0.0";

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f06ac5f2356f0964f088b1f840a6d382499054bd18539ffb1e7c84f29c2c39b6";
  };

  propagatedBuildInputs = [ requests geojson ];

  # This may actually break the package.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "requests>=2.18.2,<2.19" "requests"
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper around the OpenWeatherMap web API";
    homepage = "https://pyowm.readthedocs.io/";
    license = licenses.mit;
  };
}
