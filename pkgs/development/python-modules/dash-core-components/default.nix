{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j39hlrxscqnz77f1wfzzcmcz2ggd38svc4ipghypxag3r10xl3f";
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
