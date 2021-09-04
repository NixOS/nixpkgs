{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6733874af975e552f95a1398a16c2ee7df14ce43fa60bb3718a3c6e0b63ffee";
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
