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

buildPythonPackage {
  pname = "chart-studio";
  version = "1.1.0-unstable-2025-01-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "chart-studio";
    rev = "44c7c43be0fe7e031ec281c86ee7dae0efa0619e";
    hash = "sha256-RekcZzUcunIqXOSriW+RvpLdvATQWTeRAiR8LFodfQg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    plotly
    requests
    retrying
  ];

  nativeCheckInputs = [
    mock
    plotly
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # most tests talk to a network service, so only run ones that don't do that.
  enabledTestPaths = [
    "chart_studio/tests/test_core"
  ];

  meta = {
    description = "Utilities for interfacing with Plotly's Chart Studio service";
    homepage = "https://github.com/plotly/chart-studio";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
