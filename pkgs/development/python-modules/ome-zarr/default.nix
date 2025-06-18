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
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ome";
    repo = "ome-zarr-py";
    tag = "v${version}";
    hash = "sha256-3RXkz+UQvLixfYYhm5y/5vu9r0ga6s3xKx1azbmKFgg=";
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
  ] ++ fsspec.optional-dependencies.s3;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # attempts to access network
    "test_s3_info"
  ];

  pytestFlagsArray = [
    # Fail with RecursionError
    # https://github.com/ome/ome-zarr-py/issues/352
    "--deselect=tests/test_cli.py::TestCli::test_astronaut_download"
    "--deselect=tests/test_cli.py::TestCli::test_astronaut_info"
    "--deselect=tests/test_cli.py::TestCli::test_coins_info"
    "--deselect=tests/test_emitter.py::test_close"
    "--deselect=tests/test_emitter.py::test_create_wrong_encoding"
    "--deselect=tests/test_node.py::TestNode::test_image"
    "--deselect=tests/test_node.py::TestNode::test_label"
    "--deselect=tests/test_node.py::TestNode::test_labels"
    "--deselect=tests/test_ome_zarr.py::TestOmeZarr::test_download"
    "--deselect=tests/test_ome_zarr.py::TestOmeZarr::test_info"
    "--deselect=tests/test_reader.py::TestReader::test_image"
    "--deselect=tests/test_reader.py::TestReader::test_label"
    "--deselect=tests/test_reader.py::TestReader::test_labels"
    "--deselect=tests/test_starting_points.py::TestStartingPoints::test_label"
    "--deselect=tests/test_starting_points.py::TestStartingPoints::test_labels"
    "--deselect=tests/test_starting_points.py::TestStartingPoints::test_top_level"
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
