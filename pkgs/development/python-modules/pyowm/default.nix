{ lib, buildPythonPackage, fetchPypi, pythonOlder, requests, geojson }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "3.1.1";

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7b18297a9189dbe5f6b454b12d61a407e35c7eb9ca75bcabfe5e1c83245290d";
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
