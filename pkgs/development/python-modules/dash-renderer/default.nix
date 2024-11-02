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
    sha256 = "73a69e3d145880e68e42723ad10182251d92b44f3efe92b8763145cfd2158e7e";
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
