{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  pandas,
  poetry-core,
  pythonOlder,
  requests,
  zeep,
}:

buildPythonPackage rec {
  pname = "noaa-coops";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "noaa_coops";
    inherit version;
    hash = "sha256-m3hTzUspYTMukwcj3uBbRahTmXbL1aJVD9NXfjwghB8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pandas
    requests
    zeep
  ];

  # The package does not include tests in the PyPI source distribution
  doCheck = false;

  pythonImportsCheck = [
    "noaa_coops"
    "noaa_coops.station"
  ];

  meta = {
    description = "Python wrapper for NOAA CO-OPS Tides & Currents Data and Metadata APIs";
    homepage = "https://github.com/GClunies/noaa_coops";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
