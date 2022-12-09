{ lib
, fetchPypi
, buildPythonPackage
, types-requests
, requests
}:

buildPythonPackage rec {
  pname = "pyarr";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3DX02V3Srpx6hqimWbesxfkDqslVH4+8uXY7XYDmjX0=";
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
