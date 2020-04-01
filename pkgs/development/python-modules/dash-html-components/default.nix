{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_html_components";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "166agkrl52j5qin2npsdl2a96jccxz5f1jvcz0hxsnjg0ix0k4l9";
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
