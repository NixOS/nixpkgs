{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w6mpmvfj6nv5rdzikwc7wwhrgscbh50d0azzydhsa9jccxvkakl";
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
