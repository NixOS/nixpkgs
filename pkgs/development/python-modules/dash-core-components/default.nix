{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8cdfaf3580577670bb2d1c3168efa06f5a7b439fbe5527cfaefa3e32394542f";
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
