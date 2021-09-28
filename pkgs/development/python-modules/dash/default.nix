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
, setuptools
, pytest-mock
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f5r2cqwa659rc61qa7zl1nqn7i1pr2ychydrfr92h1hm7kc06yi";
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
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    mock
    pytest-mock
  ];

  pytestFlagsArray = [
    "tests/unit/test_{configs,fingerprint,resources}.py"
    "tests/unit/dash"
  ];

  pythonImportsCheck = ["dash"];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
