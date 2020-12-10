{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55423dfe0ede92b2efdb6dee6b7d44be141ca1e2e06f1a0effd4e7c83c929d4d";
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
