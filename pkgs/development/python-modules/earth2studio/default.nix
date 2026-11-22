{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  cftime,
  cupy,
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
  pyproj,
  python-dotenv,
  rich,
  s3fs,
  torch,
  tqdm,
  xarray,
  zarr,

  # tests
  eccodes,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  scipy,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "earth2studio";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "earth2studio";
    tag = finalAttrs.version;
    hash = "sha256-qN4pzsGBuNkOR+ehswdSoQzdGr53TvF5jx3qorNeisQ=";
  };

  postPatch =
    # Upstream tags the release without dropping the rc suffix from the version source
    ''
      substituteInPlace earth2studio/__init__.py \
        --replace-fail \
          '__version__ = "${finalAttrs.version}a0"' \
          '__version__ = "${finalAttrs.version}"'
    '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "netcdf4"
  ];
  pythonRemoveDeps = [
    # CUDA-specific wheel names; `cupy` is provided under `cudaSupport` and `rmm` is optional
    "cupy-cuda13x"
    "rmm-cu13"
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
    pyproj
    python-dotenv
    rich
    s3fs
    torch
    tqdm
    xarray
    zarr
  ]
  ++ xarray.optional-dependencies.parallel
  ++ lib.optionals config.cudaSupport [ cupy ];

  pythonImportsCheck = [ "earth2studio" ];

  nativeCheckInputs = [
    eccodes
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    scipy
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
    "test_netcdf4_memory_store"
    "test_netcdf4_variable"

    # The `cuda:0` device parametrization is not covered by the `cuda` mark
    "cuda"
    # ImportError: cupy is required for CUDA DataArrays
    "test_native_mapping_preserves_storage_and_rejects_wrong_geometry"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # oneDNN's aarch64 JIT fails to assemble the convolution kernel:
    # https://github.com/pytorch/pytorch/issues/179710
    "test_fss"

    # RuntimeError: Failed to initialize cpuinfo! (no sysfs in the sandbox)
    "test_derived_pressure_levels_in_half_precision"
    "test_derived_rh_float16_pressure_precision"
    "test_moments_float16_large_reduction"
  ];

  disabledTestPaths = [
    # Tests for upstream's CI data-test runner, which spawns pytest with custom plugins
    "test/_ci"

    # Require network access
    "test/data"
    "test/models/test_auto_models.py"
  ];

  # Distributed pipeline tests bind a local port for `torchrun`
  __darwinAllowLocalNetworking = true;

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
