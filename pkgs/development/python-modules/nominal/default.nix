{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  nominal-api,
  nominal-streaming-py,
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
  pythonRelaxDepsHook,
  cachetools,
  openpyxl,
  polars,
  rich,
  truststore,
  urllib3,
}:

buildPythonPackage rec {
  pname = "nominal";
  version = "1.104.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nominal-io";
    repo = "nominal-client";
    tag = "v${version}";
    hash = "sha256-+hJzDQND+eQ/za+V7HXHhwoGfIusXBUUWWSYwWu39ew=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    conjure-python-client
    nominal-api
    nominal-streaming-py
    python-dateutil
    pandas
    typing-extensions
    click
    pyyaml
    tabulate
    ffmpeg-python
    cachetools
    openpyxl
    polars
    rich
    truststore
    urllib3
  ];

  optional-dependencies = {
    protos = [ nominal-api-protos ];
    # tdms = [ nptdms ]; nptdms is not in nixpkgs
  };

  pythonRemoveDeps = [
    "types-cachetools" # typing stubs, not needed at runtime
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [
    nominal-api-protos
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nominal"
    "nominal.core"
  ];

  pythonRelaxDeps = [
    "nominal-api"
    "urllib3"
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
