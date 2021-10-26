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
, pytest-mock
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0RvA5qkwQJGyy81D5kW+IR6LbaD/KBwMy6kYxTETubg=";
  };

  propagatedBuildInputs = [
    plotly
    flask
    flask-compress
    dash-core-components
    dash-html-components
    dash-table
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    mock
  ];

  disabledTestPaths = [
    "tests/unit/test_browser.py"
    "tests/unit/test_app_runners.py" # Use selenium
    "tests/integration"
  ];

  pythonImportsCheck = [ "dash" ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
