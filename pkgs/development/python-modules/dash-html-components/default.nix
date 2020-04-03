{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_html_components";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fj5wlh6x9nngmz1rzb5xazc5pl34yrp4kf7a3zgy0dniap59yys";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "HTML components for Dash";
    homepage = https://dash.plot.ly/dash-html-components;
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
