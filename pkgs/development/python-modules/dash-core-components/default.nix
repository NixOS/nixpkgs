{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f92025b12931539cdda2173f2b4cd077119cbabbf3ddf62333f6302fd0d8a3ac";
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
