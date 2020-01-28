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
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "v${version}";
    sha256 = "11skbvjlj93aw1pqx6j56h73sy9r06jwq7z5h64fd1a3d4z2gsvy";
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
    pytest tests/unit/test_configs.py
    pytest tests/unit/test_fingerprint.py
    pytest tests/unit/test_import.py
    pytest tests/unit/test_resources.py
    pytest tests/unit/dash/
  '';

  pythonImportsCheck = [
    "dash"
  ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = https://dash.plot.ly/;
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
