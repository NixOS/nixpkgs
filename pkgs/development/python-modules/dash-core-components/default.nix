{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e503f5eddb63034dd20c23d218cc0d8a81ec88e9a15b7cbc60e266b0e2b60a9";
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
