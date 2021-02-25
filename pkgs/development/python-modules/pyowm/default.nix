{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, geojson
, pysocks
}:

buildPythonPackage rec {
  pname = "pyowm";
  version = "3.2.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o9QL2KtZdRa/uFq+tq8LDm5jRovNuma96qOSDK/hqN4=";
  };

  propagatedBuildInputs = [
    geojson
    pysocks
    requests
  ];

  # This may actually break the package.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "requests>=2.18.2,<2.19" "requests"
  '';

  # No tests in archive
  doCheck = false;
  pythonImportsCheck = [ "" ];

  meta = with lib; {
    description = "Python wrapper around the OpenWeatherMap web API";
    homepage = "https://pyowm.readthedocs.io/";
    license = licenses.mit;
  };
}
