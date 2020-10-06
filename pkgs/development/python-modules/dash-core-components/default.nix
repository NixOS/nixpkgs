{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27f2ac612f5574dcd0d645f9302ceca5975bbdac6791865692e3ac51d0aec7f4";
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
