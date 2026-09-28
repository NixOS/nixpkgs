{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  cftime,
  fsspec,
  gcsfs,
  h5netcdf,
  h5py,
  huggingface-hub,
  loguru,
  netcdf4,
  obspec,
  obstore,
  pandas,
  pyarrow,
  pygrib,
  python-dotenv,
  rich,
  s3fs,
  torch,
  tqdm,
  xarray,
  zarr,

  # tests
  aiofiles,
  eccodes,
  fastapi,
  hydra-core,
  pydantic,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  redis,
  rq,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "earth2studio";
  version = "0.18.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "earth2studio";
    tag = finalAttrs.version;
    hash = "sha256-7YXuqlfKB91uwPP/1GOThpnHS/VjPYYb/kCuFqebOVk=";
  };

  postPatch =
    # Upstream tags the release without dropping the rc suffix from the version source
    ''
      substituteInPlace earth2studio/__init__.py \
        --replace-fail \
          '__version__ = "${finalAttrs.version}rc0"' \
          '__version__ = "${finalAttrs.version}"'
    '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "netcdf4"
  ];
  dependencies = [
    cftime
    fsspec
    gcsfs
    h5netcdf
    h5py
    huggingface-hub
    loguru
    netcdf4
    obspec
    obstore
    pandas
    pyarrow
    pygrib
    python-dotenv
    rich
    s3fs
    torch
    tqdm
    xarray
    zarr
  ];

  pythonImportsCheck = [ "earth2studio" ];

  nativeCheckInputs = [
    aiofiles
    eccodes
    fastapi
    hydra-core
    pydantic
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    redis
    rq
    writableTmpDirAsHomeHook
  ];

  disabledTestMarks = [
    # Disable all tests that require GPU access
    "cuda"
  ];

  disabledTests = [
    # Flaky: races two timings against each other
    "test_async_zarr_non_blocking"

    # netCDF4 compares library versions as strings, so `diskless` support is wrongly rejected with
    # netcdf-c 4.10:
    # https://github.com/Unidata/netcdf4-python/issues/1475
    "test_netcdf4_exceptions"
    "test_netcdf4_fields"
    "test_netcdf4_fields_multidim"
    "test_netcdf4_variable"

    # The `cuda:0` device parametrization is not covered by the `cuda` mark
    "cuda"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # oneDNN's aarch64 JIT fails to assemble the convolution kernel:
    # https://github.com/pytorch/pytorch/issues/179710
    "test_fss"
  ];

  disabledTestPaths = [
    # Require network access
    "test/data"
    "test/models/test_auto_models.py"

    # Requires `dask`
    "test/utils/test_cupy.py"
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs (prev: {
    requiredSystemFeatures = [ "cuda" ];
    disabledTestMarks = [ ];
    disabledTests = lib.remove "cuda" prev.disabledTests;
  });

  meta = {
    description = "Open-source deep-learning framework for exploring, building and deploying AI weather/climate workflows";
    homepage = "https://github.com/NVIDIA/earth2studio";
    changelog = "https://github.com/NVIDIA/earth2studio/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
