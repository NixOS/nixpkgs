{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fbcc3a88f8c51d190b697c80515e67530143de71f89cc6ecf99bbf2cbf3ef30";
  };

  propagatedBuildInputs = [ requests ];

  # Upstream provides no unit tests.
  doCheck = false;

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = https://github.com/jabesq/netatmo-api-python;
    maintainers = with maintainers; [ delroth ];
  };
}
