{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13ca794416707b8cefcb7584bbfff65a4640fcc2510ad73e818fef94d424fca6";
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
