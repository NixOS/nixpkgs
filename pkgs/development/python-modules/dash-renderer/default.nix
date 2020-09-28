{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84cbb22019299a5a3c268ec1143c6f241c3f136e95753edac83a81673b7fa04e";
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
