{ lib, buildPythonPackage, fetchFromGitHub
, mock
, nose
, plotly
, pytest
, requests
, retrying
, six
}:

buildPythonPackage rec {
  pname = "chart-studio";
  version = "5.15.0";

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-H+p2fPBXn+VqrW63KkdmPn2xqxC9uAOzQUV1ruKEUSs=";
  };

  sourceRoot = "source/packages/python/chart-studio";

  propagatedBuildInputs = [
    plotly
    requests
    retrying
    six
  ];

  nativeCheckInputs = [ mock nose pytest ];
  # most tests talk to a service
  checkPhase = ''
    HOME=$TMPDIR pytest chart_studio/tests/test_core chart_studio/tests/test_plot_ly/test_api
  '';

  meta = with lib; {
    description = "Utilities for interfacing with Plotly's Chart Studio service";
    homepage = "https://github.com/plotly/plotly.py/tree/master/packages/python/chart-studio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jonringer ];
  };
}
