{ lib
, buildPythonPackage
, fetchPypi
, urllib3
, requests
}:

buildPythonPackage rec {
  pname = "py-synologydsm-api";
  version = "1.0.2";

  src = fetchPypi {
    pname = "synologydsm-api";
    inherit version;
    sha256 = "42ea453ef5734dd5b8163e3d18ef309658f0298411720e6b834bededd28c5d53";
  };

  propagatedBuildInputs = [ urllib3 requests ];

  pythonImportsCheck = [
    "synology_dsm"
  ];

  meta = with lib; {
    description = "Python API for Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
