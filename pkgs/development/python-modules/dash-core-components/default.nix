{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wr6989hq7q9vyh1qqdpbp8igk9rfca4phfpaim3nnk4swvm5m75";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A dash component starter pack";
    homepage = "https://dash.plot.ly/dash-core-components";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
