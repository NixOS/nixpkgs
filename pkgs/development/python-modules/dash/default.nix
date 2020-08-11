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
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f7gal9x0bjsmwxlbvlkwfwz1cyyg5d0n6jh4399wkjilpd966d5";
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
