{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  dask,
  numpy,
  python-dateutil,
  spatial-image,
  xarray,
  xarray-dataclass,
  zarr,
  dask-image,
  fsspec,
  jsonschema,
  nbmake,
  pooch,
  pytestCheckHook,
  pytest-mypy,
  urllib3,
}:

buildPythonPackage rec {
  pname = "multiscale-spatial-image";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spatial-image";
    repo = "multiscale-spatial-image";
    tag = "v${version}";
    hash = "sha256-wKSzhlNXIXOFEK8+xfKF6zTFr0+mdFhhvjWiHAKphk0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    dask
    numpy
    python-dateutil
    spatial-image
    xarray
    xarray-dataclass
    zarr
  ];

  optional-dependencies = {
    dask-image = [ dask-image ];
    #itk = [
    #  itk-filtering # not in nixpkgs yet
    #];
    test = [
      dask-image
      fsspec
      #ipfsspec # not in nixpkgs
      #itk-filtering # not in nixpkgs
      jsonschema
      nbmake
      pooch
      pytest-mypy
      urllib3
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.test;

  doCheck = false; # all test files try to download data

  pythonImportsCheck = [ "multiscale_spatial_image" ];

  meta = {
    description = "Generate a multiscale, chunked, multi-dimensional spatial image data structure that can serialized to OME-NGFF";
    homepage = "https://github.com/spatial-image/multiscale-spatial-image";
    changelog = "https://github.com/spatial-image/multiscale-spatial-image/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
