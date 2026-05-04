{
  lib,
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
  fastapi,
  hydra-core,
  pydantic,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  redis,
  rq,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "earth2studio";
  version = "0.15.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "earth2studio";
    tag = finalAttrs.version;
    hash = "sha256-7eVP9qljpLAqflUOcp3yAimnwROTJqzzFiUUCFYbpLs=";
  };

  build-system = [
    hatchling
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

  pytestFlags = [
    "--timeout=30"
  ];

  nativeCheckInputs = [
    aiofiles
    fastapi
    hydra-core
    pydantic
    pytest-asyncio
    # pytest-xdist
    pytestCheckHook
    redis
    rq
    pytest-timeout
    # redisTestHook
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [
    "test/data"
  ];

  disabledTestPaths = [
    # Require internet connection
    "test/data/test_arco.py"
    "test/data/test_cmip6.py"
    "test/data/test_ecmwf.py"
    "test/data/test_goes.py"
  ];

  disabledTests = [
    # Require internet connection
    "test_ace2era5_cache"
    "test_ace2era5_co2_fn_override"
    "test_ace2era5_forcing_fetch"
    "test_ace2era5_ic_fetch"
    "test_cams_fx_cache"
    "test_cams_fx_fetch"
    "test_gfs_available"
    "test_gfs_fetch"
    "test_gfs_fx_fetch"
    "test_ghcn_cache"
    "test_ghcn_fetch"
    "test_goes_glm_fetch"
    "test_ifs_ens_fx_fetch"
    "test_ifs_fetch"
    "test_isd_exceptions"
    "test_jpss_available"
    "test_jpss_cache"
    "test_jpss_cris_cache"
    "test_jpss_cris_fetch"
    "test_jpss_fetch"
    "test_lsm_fetch"
    "test_metop_amsua_cache"
    "test_mrms_fetch"
    "test_wb2era5_fetch"
  ];

  meta = {
    description = "Open-source deep-learning framework for exploring, building and deploying AI weather/climate workflows";
    homepage = "https://github.com/NVIDIA/earth2studio";
    changelog = "https://github.com/NVIDIA/earth2studio/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
