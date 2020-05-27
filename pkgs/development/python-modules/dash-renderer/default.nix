{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11fl7756zshlrfiqcr6rcg1m0c4434vdg1bkrcjl54hl02k3pcmv";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Renderer for the Dash framework";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
