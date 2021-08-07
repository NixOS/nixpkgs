{ lib
, buildPythonPackage
, fetchFromGitHub
, plotly
, flask
, flask-compress
, future
, dash-core-components
, dash-renderer
, dash-html-components
, dash-table
, pytest
, pytest-mock
, mock
}:

buildPythonPackage rec {
  pname = "dash";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "1205xwi0w33g3c8gcba50fjj38dzgn7nhfk5w186kd6dwmvz02yg";
  };

  propagatedBuildInputs = [
    plotly
    flask
    flask-compress
    future
    dash-core-components
    dash-renderer
    dash-html-components
    dash-table
  ];

  checkInputs = [
    pytest
    pytest-mock
    mock
  ];

  checkPhase = ''
    pytest tests/unit/test_{configs,fingerprint,resources}.py \
      tests/unit/dash/
  '';

  pythonImportsCheck = [
    "dash"
  ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
