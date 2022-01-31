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
  version = "5.5.0";

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "v${version}";
    sha256 = "04hsh1z2ngfslmvi8fdzfccssg6i0ziksil84j129f049m96wd51";
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
