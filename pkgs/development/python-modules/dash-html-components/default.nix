{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_html_components";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc4f423e13716d179d51a42b3c7e2a2ed02e05185c742f88214b58d59e24bbd4";
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
