{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-html-components";
  version = "1.0.1";

  src = fetchPypi {
    inherit version;
    pname = "dash_html_components";
    sha256 = "7d7e80bf12635eb7d281fb0e7dd4b6e53f10dd57e3384ea5044c44ab16454fe4";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "Vanilla HTML components for Dash";
    homepage = https://github.com/plotly/dash-html-components;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jdehaas ];
  };

}
