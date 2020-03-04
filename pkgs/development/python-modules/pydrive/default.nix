{ lib
, buildPythonPackage
, fetchPypi
, google_api_python_client
, oauth2client
, pyyaml
}:

buildPythonPackage rec {
  pname = "pydrive";
  version = "1.3.1";

  src = fetchPypi {
    pname = "PyDrive";
    inherit version;
    sha256 = "11q7l94mb34hfh9wkdwfrh5xw99y13wa33ba7xp1q23q4b60v2c3";
  };

  propagatedBuildInputs = [
    google_api_python_client
    oauth2client
    pyyaml
  ];

  # requires client_secrets.json
  doCheck = false;

  meta = {
    description = "Google Drive API Python wrapper library";
    homepage = "https://github.com/gsuitedevs/PyDrive";
    license = lib.licenses.asl20;
  };
}
