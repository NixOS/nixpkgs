{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "097195ebe69267732d2fba30825f72c2b6ec3e127f60648c64e8d248d275a89b";
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
