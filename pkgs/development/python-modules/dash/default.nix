{ lib
, buildPythonPackage
, fetchPypi
# install deps
, dash-core-components
, dash-html-components
, dash-renderer
, dash-table
, flask
, flask-compress
, future
, plotly
}:

buildPythonPackage rec {
  pname = "dash";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "418cc08bd546b8c365986dd49c3f1cb6076b5b660829db68d05fd910f9d0a8f7";
  };

  propagatedBuildInputs = [
    dash-core-components
    dash-html-components
    dash-renderer
    dash-table
    future
    flask
    flask-compress
    plotly
  ];

  doCheck = false; # no tests included

  meta = with lib; {
    description = "Framework for building analytical web applications";
    homepage = https://plot.ly/dash/;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jdehaas ];
  };

}
