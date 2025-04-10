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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "chart-studio";
  version = "1.1.0-unstable-2025-01-30";
  pyproject = true;

  # chart-studio was split from plotly
  src = fetchFromGitHub {
    owner = "plotly";
    repo = "chart-studio";
    rev = "44c7c43be0fe7e031ec281c86ee7dae0efa0619e";
    hash = "sha256-RekcZzUcunIqXOSriW+RvpLdvATQWTeRAiR8LFodfQg=";
  };

  prePatch = ''
    substituteInPlace chart_studio/api/v2/utils.py --replace-fail \
      "version.stable_semver()" "version"

    substituteInPlace chart_studio/tests/test_plot_ly/test_api/test_v2/test_utils.py --replace-fail \
      "version.stable_semver()" "version"
  '';

  build-system = [ setuptools ];

  dependencies = [
    plotly
    requests
    retrying
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

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
