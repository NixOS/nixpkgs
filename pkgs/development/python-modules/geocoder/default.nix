{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, click
, future
, ratelim
, requests
, six
}:

buildPythonPackage rec {
  pname = "geocoder";
  version = "1.38.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yZJTdMlhV30K7kA7Ceb46hlx2RPwEfAMpwx2vq96d+c=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    click
    future
    ratelim
    requests
    six
  ];

  pythonImportsCheck = [ "geocoder" ];

  # Most of the tests require either:
  # - internet access
  # - API key
  # - results files not present in the Pypi archive
  doCheck = false;

  meta = with lib; {
    description = "Geocoder is a simple and consistent geocoding library";
    homepage = "https://pypi.org/project/geocoder";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
