{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, aiohttp
, dask
, distributed
, fsspec
, numpy
, requests
, scikit-image
, toolz
, zarr
}:

buildPythonPackage rec {
  pname = "ome-zarr";
  version = "0.8.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ome";
    repo = "ome-zarr-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-JuNXVse/n/lFbNaLwMcir8NBHiRxcbYvtbxePwI6YoY=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # attempts to access network
    "test_s3_info"
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
    description = "Implementation of next-generation file format (NGFF) specifications for storing bioimaging data in the cloud.";
    homepage = "https://pypi.org/project/ome-zarr";
    changelog = "https://github.com/ome/ome-zarr-py/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = [ maintainers.bcdarwin ];
    mainProgram = "ome_zarr";
  };
}
