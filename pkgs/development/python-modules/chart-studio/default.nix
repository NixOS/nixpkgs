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
<<<<<<< HEAD
  version = "5.16.1";
=======
  version = "5.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-R94fmkz9cydOHKQbXMBR47OCdHHsR25uGiGszcr7AQQ=";
  };

  sourceRoot = "${src.name}/packages/python/chart-studio";
=======
    hash = "sha256-LcCptMtRxXQPbghMIunrPcSLAXQ/r3xVktueMUQ0+gE=";
  };

  sourceRoot = "source/packages/python/chart-studio";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
