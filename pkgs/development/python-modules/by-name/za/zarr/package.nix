{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  donfig,
  numpy,
  numcodecs,
  packaging,
  typing-extensions,

  # tests
  hypothesis,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F9ty838kiUUtITesiRxBM7j5dvkYnY79PnXzs63YTow=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    donfig
    numcodecs
    numpy
    packaging
    typing-extensions
  ]
  ++ numcodecs.optional-dependencies.crc32c;

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    tomlkit
  ];

  disabledTestPaths = [
    # requires uv and then fails at setting up python envs
    "tests/test_examples.py"
  ];

  pythonImportsCheck = [ "zarr" ];

  # FIXME remove once zarr's reverse dependencies support v3
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
