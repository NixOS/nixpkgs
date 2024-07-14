{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c6aePRRYgOaOQnI60QGCJR2StE8+/pK4djFFz9IVjn4=";
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
