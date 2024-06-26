{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  aiohttp,
  dask,
  distributed,
  fsspec,
  numpy,
  requests,
  scikit-image,
  toolz,
  zarr,
}:

buildPythonPackage rec {
  pname = "ome-zarr";
  version = "0.9.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ome";
    repo = "ome-zarr-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-YOG9+ONf2OnkSZBL/Vb8Inebx4XDSGJb2fqypaWebhY=";
  };

  propagatedBuildInputs = [
    numpy
    dask
    distributed
    zarr
    fsspec
    aiohttp
    requests
    scikit-image
    toolz
  ] ++ fsspec.passthru.optional-dependencies.s3;

  nativeCheckInputs = [ pytestCheckHook ];

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

  meta = with lib; {
    description = "Implementation of next-generation file format (NGFF) specifications for storing bioimaging data in the cloud";
    homepage = "https://pypi.org/project/ome-zarr";
    changelog = "https://github.com/ome/ome-zarr-py/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = [ maintainers.bcdarwin ];
    mainProgram = "ome_zarr";
  };
}
