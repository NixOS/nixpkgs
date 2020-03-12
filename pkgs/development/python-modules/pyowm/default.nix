{ lib, buildPythonPackage, fetchPypi, pythonOlder, requests, geojson }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "2.10.0";

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fd41a18536f4d6c432bc6d9ea69994efb1ea9b43688cf19523659b6f4d86cf7";
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
    homepage = https://pyowm.readthedocs.io/;
    license = licenses.mit;
  };
}
