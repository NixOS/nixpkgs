{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-html-components";
  version = "2.0.0";

  src = fetchPypi {
    pname = "dash_html_components";
    inherit version;
    sha256 = "8703a601080f02619a6390998e0b3da4a5daabe97a1fd7a9cebc09d015f26e50";
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
