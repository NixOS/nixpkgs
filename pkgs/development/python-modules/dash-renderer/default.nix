{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7ab2b922f4f0850bae0e9793cec99f8a1a241e5f7f5786e367ddd9e41d2b170";
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
