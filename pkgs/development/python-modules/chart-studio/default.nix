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
  version = "5.2.2";

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "v${version}";
    sha256 = "14msi6i2caca5riirfv81nskh8w3avnflyr2phm62kygk125h1v7";
  };

  sourceRoot = "source/packages/python/chart-studio";

  propagatedBuildInputs = [
    plotly
    requests
    retrying
    six
  ];

  checkInputs = [ mock nose pytest ];
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
