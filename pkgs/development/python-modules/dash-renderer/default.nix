{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e9c0c0c2efb8ea562489c37665417cd608c30bca20425ac4d847420b5bbc128";
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
