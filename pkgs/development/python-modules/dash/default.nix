{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, plotly
, flask
, flask-compress
, dash-core-components
, dash-html-components
, dash-table
, pytest-mock
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7B1LEcEgUGJ/gDCDD4oURqli8I5YTJo9jl7l4E1aLVQ=";
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
    broken = stdenv.isDarwin;
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
