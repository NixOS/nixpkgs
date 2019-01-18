{ lib, buildPythonPackage, fetchPypi, requests, geojson, isPy27 }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xvcv3sbcn9na8cwz21nnjlixysfk5lymnf65d1nqkbgacc1mm4g";
  };

  disabled = isPy27;

  propagatedBuildInputs = [ requests geojson ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper around the OpenWeatherMap web API";
    homepage = https://pyowm.readthedocs.io/;
    license = licenses.mit;
  };
}
