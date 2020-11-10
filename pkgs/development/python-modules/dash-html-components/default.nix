{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_html_components";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c662e640528c890aaa0fa23d48e51c4d13ce69a97841d856ddcaaf2c6a47be3";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "HTML components for Dash";
    homepage = "https://dash.plot.ly/dash-html-components";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
