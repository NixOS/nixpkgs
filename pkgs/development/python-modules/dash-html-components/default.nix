{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dash-html-components";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "dash_html_components";
    inherit version;
    hash = "sha256-hwOmAQgPAmGaY5CZjgs9pKXaq+l6H9epzrwJ0BXyblA=";
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
