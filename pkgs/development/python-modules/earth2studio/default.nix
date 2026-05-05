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
  nest-asyncio,
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
  pydantic,
  pytestCheckHook,
  redis,
  redisTestHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "earth2studio";
  version = "0.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "earth2studio";
    tag = finalAttrs.version;
    hash = "sha256-K6pGYIzCRlg4u7I8uhYjmkw09RdU0MNFC+RPAqT2Tl8=";
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
    nest-asyncio
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

  nativeCheckInputs = [
    aiofiles
    pydantic
    pytestCheckHook
    redis
    redisTestHook
  ];

  meta = {
    description = "Open-source deep-learning framework for exploring, building and deploying AI weather/climate workflows";
    homepage = "https://github.com/NVIDIA/earth2studio";
    changelog = "https://github.com/NVIDIA/earth2studio/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
