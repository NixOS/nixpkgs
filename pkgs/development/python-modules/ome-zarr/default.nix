{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aiohttp,
  dask,
  fsspec,
  numpy,
  requests,
  scikit-image,
  toolz,
  zarr,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ome-zarr";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ome";
    repo = "ome-zarr-py";
    tag = "v${version}";
    hash = "sha256-lwv6PHm41HFylt7b0d5LHCrCIXNWFNGg59VQvPXYtVc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    dask
    fsspec
    numpy
    requests
    scikit-image
    toolz
    zarr
  ]
  ++ fsspec.optional-dependencies.s3;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # attempts to access network
    "test_s3_info"
  ];

  disabledTestPaths = [
    # Fail with RecursionError
    # https://github.com/ome/ome-zarr-py/issues/352
    "tests/test_cli.py::TestCli::test_astronaut_download"
    "tests/test_cli.py::TestCli::test_astronaut_info"
    "tests/test_cli.py::TestCli::test_coins_info"
    "tests/test_emitter.py::test_close"
    "tests/test_emitter.py::test_create_wrong_encoding"
    "tests/test_node.py::TestNode::test_image"
    "tests/test_node.py::TestNode::test_label"
    "tests/test_node.py::TestNode::test_labels"
    "tests/test_ome_zarr.py::TestOmeZarr::test_download"
    "tests/test_ome_zarr.py::TestOmeZarr::test_info"
    "tests/test_reader.py::TestReader::test_image"
    "tests/test_reader.py::TestReader::test_label"
    "tests/test_reader.py::TestReader::test_labels"
    "tests/test_starting_points.py::TestStartingPoints::test_label"
    "tests/test_starting_points.py::TestStartingPoints::test_labels"
    "tests/test_starting_points.py::TestStartingPoints::test_top_level"

    # tries to access network:
    "ome_zarr/io.py"
  ];

  pythonImportsCheck = [
    "ome_zarr"
    "ome_zarr.cli"
    "ome_zarr.csv"
    "ome_zarr.data"
    "ome_zarr.format"
    "ome_zarr.io"
    "ome_zarr.reader"
    "ome_zarr.writer"
    "ome_zarr.scale"
    "ome_zarr.utils"
  ];

  meta = {
    description = "Implementation of next-generation file format (NGFF) specifications for storing bioimaging data in the cloud";
    homepage = "https://pypi.org/project/ome-zarr";
    changelog = "https://github.com/ome/ome-zarr-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bcdarwin ];
    mainProgram = "ome_zarr";
  };
}
