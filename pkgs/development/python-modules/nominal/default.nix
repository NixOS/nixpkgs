{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  nominal-api,
  nominal-api-protos,
  python-dateutil,
  conjure-python-client,
  pandas,
  typing-extensions,
  click,
  pyyaml,
  tabulate,
  ffmpeg-python,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nominal";
  version = "1.71.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nominal-io";
    repo = "nominal-client";
    tag = "v${version}";
    hash = "sha256-C0afrzWlq2Z3a21MIJ/3XgvjkEZONwBgCZ+06XIYFGE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    conjure-python-client
    nominal-api
    python-dateutil
    pandas
    typing-extensions
    click
    pyyaml
    tabulate
    ffmpeg-python
  ];

  optional-dependencies = {
    protos = [ nominal-api-protos ];
    # tdms = [ nptdms ]; nptdms is not in nixpkgs
  };

  nativeCheckInputs = [
    nominal-api-protos
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nominal"
    "nominal.core"
  ];

  disabledTestPaths = [
    "tests/cli/test_auth.py::test_good_request"
  ];

  meta = {
    description = "Automate Nominal workflows in Python";
    homepage = "https://github.com/nominal-io/nominal-client";
    changelog = "https://github.com/nominal-io/nominal-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alkasm ];
  };
}
