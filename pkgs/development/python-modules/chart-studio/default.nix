{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  plotly,
  requests,
  retrying,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "chart-studio";
  version = "1.1.0-unstable-2024-07-23";
  pyproject = true;

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    # We use plotly's upstream version as it's the same repo, but chart studio has its own version number.
    rev = "v5.23.0";
    hash = "sha256-K1hEs00AGBCe2fgytyPNWqE5M0jU5ESTzynP55kc05Y=";
  };

  sourceRoot = "${src.name}/packages/python/chart-studio";

  build-system = [ setuptools ];

  dependencies = [
    plotly
    requests
    retrying
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # most tests talk to a network service, so only run ones that don't do that.
  pytestFlagsArray = [
    "chart_studio/tests/test_core"
    "chart_studio/tests/test_plot_ly/test_api"
  ];

  meta = {
    description = "Utilities for interfacing with Plotly's Chart Studio service";
    homepage = "https://github.com/plotly/plotly.py/tree/master/packages/python/chart-studio";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
