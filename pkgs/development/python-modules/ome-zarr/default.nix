{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, aiohttp
, dask
, fsspec
, numpy
, requests
, scikitimage
, s3fs
, toolz
, zarr
}:

buildPythonPackage rec {
  pname = "ome-zarr";
  version = "0.6.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ome";
    repo = "ome-zarr-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-dpweOuqruh7mAqmSaNbehLCr8OCLe1IZNWV4bpHpTl0=";
  };

  patches = [
    # remove after next release:
    (fetchpatch {
      name = "fix-writer-bug";
      url = "https://github.com/ome/ome-zarr-py/commit/c1302e05998dfe2faf94b0f958c92888681f5ffa.patch";
      hash = "sha256-1WANObABUXkjqeGdnmg0qJ48RcZcuAwgitZyMwiRYUw=";
    })
  ];

  propagatedBuildInputs = [
    numpy
    dask
    zarr
    fsspec
    aiohttp
    requests
    s3fs
    scikitimage
    toolz
  ];

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
