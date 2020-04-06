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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "18rrysfhmjfzb5b3n8fjbwk755p4slbb8fh9myq4qp76v00lfpnh";
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
    pytest tests/unit/test_{configs,fingerprint,import,resources}.py \
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
