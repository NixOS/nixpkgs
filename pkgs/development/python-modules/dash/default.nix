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
  version = "2.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-OcY4nEtIfR9nvBaBwpHeUJkHXwWZp+LZxjhEkwjRC9k=";
  };

  propagatedBuildInputs = [
    dash-core-components
    dash-html-components
    dash-table
    flask
    flask-compress
    plotly
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
    mock
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  disabledTestPaths = [
    "tests/unit/test_browser.py"
    "tests/unit/test_app_runners.py" # Use selenium
    "tests/integration"
  ];

  disabledTests = [
    # Failed: DID NOT RAISE <class 'ImportError'>
    "test_missing_flask_compress_raises"
  ];

  pythonImportsCheck = [
    "dash"
  ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    changelog = "https://github.com/plotly/dash/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ antoinerg ];
  };
}
