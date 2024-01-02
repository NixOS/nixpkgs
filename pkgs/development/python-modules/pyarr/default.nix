{ lib
, fetchPypi
, buildPythonPackage
, types-requests
, requests
}:

buildPythonPackage rec {
  pname = "pyarr";
  version = "5.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jlcc9Kj1MYSsnvJkKZXXWWJVDx3KIuojjbGtl8kDUpw=";
  };

  propagatedBuildInputs = [
    requests
    types-requests
  ];

  pythonImportsCheck = [ "pyarr" ];

  meta = with lib; {
    description = "Python client for Servarr API's (Sonarr, Radarr, Readarr, Lidarr)";
    homepage = "https://github.com/totaldebug/pyarr";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
