{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c76740e5adbf8b14d8f41d4f84ce23c0e8e738b18b926dc60858c35bf2fa8f2";
  };

  # Upstream provides no unit tests.
  doCheck = false;

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = https://github.com/jabesq/netatmo-api-python;
    maintainers = with maintainers; [ delroth ];
  };
}
