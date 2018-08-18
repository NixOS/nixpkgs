{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyowm";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y2r322pcamabar70513pbyiq26x33l1aq9cim6k30lk9p4aq310";
  };

  propagatedBuildInputs = [ requests ];

  # This may actually break the package.
  postPatch = ''
    substituteInPlace setup.py --replace "requests>=2.18.2,<2.19" "requests"
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper around the OpenWeatherMap web API";
    homepage = https://pyowm.readthedocs.io/;
    license = licenses.mit;
  };
}
