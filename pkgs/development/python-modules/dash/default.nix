{ lib
, buildPythonPackage
, celery
, dash-core-components
, dash-html-components
, dash-table
, diskcache
, fetchFromGitHub
, flask
, flask-compress
, mock
, multiprocess
, plotly
, psutil
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kxat6CjX4xPEtlhRiYJF5wN2Luds7DduZyiUA9/kKWY=";
  };

  propagatedBuildInputs = [
    plotly
    flask
    flask-compress
    dash-core-components
    dash-html-components
    dash-table
  ];

  passthru.optional-dependencies = {
    celery = [
      celery
      redis
    ];
    diskcache = [
      diskcache
      multiprocess
      psutil
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    mock
    pyyaml
  ];

  disabledTestPaths = [
    "tests/unit/test_browser.py"
    "tests/unit/test_app_runners.py" # Use selenium
    "tests/integration"
  ];

  pythonImportsCheck = [
    "dash"
  ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = with maintainers; [ antoinerg ];
  };
}
