{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c5519a781beb2261ee73b2d193bef6f212697636f204acd7d58cd986ba88e30";
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
