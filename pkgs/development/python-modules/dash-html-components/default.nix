{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_html_components";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88adb77a674d5d7d0835d71c469f6e7b4aa692f9673808a474d244b71863c58a";
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
