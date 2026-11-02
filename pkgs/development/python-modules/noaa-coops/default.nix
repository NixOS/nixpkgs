{
  lib,
  buildPythonPackage,
  fetchPypi,
  pandas,
  requests,
  zeep,
  hatchling,
}:

buildPythonPackage rec {
  pname = "noaa-coops";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "noaa_coops";
    inherit version;
    hash = "sha256-VF7mYnaZ2Qnk0DX64U9c2PQ1mMzWMk6IhA1qoYEAP94=";
  };

  build-system = [ hatchling ];

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
