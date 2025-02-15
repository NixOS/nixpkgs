{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  aiohttp,
  awkward,
  cachetools,
  cloudpickle,
  correctionlib,
  dask,
  dask-awkward,
  dask-histogram,
  fsspec-xrootd,
  hist,
  lz4,
  matplotlib,
  mplhep,
  numba,
  numpy,
  packaging,
  pandas,
  pyarrow,
  requests,
  scipy,
  toml,
  tqdm,
  uproot,
  vector,

  # checks
  distributed,
  pyinstrument,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2025.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    tag = "v${version}";
    hash = "sha256-AGYi1w4e8XJOWRbuPX5eB/rTY5dCPji49zD0VQ4FvAs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRelaxDeps = [
    "dask"
  ];

  dependencies = [
    aiohttp
    awkward
    cachetools
    cloudpickle
    correctionlib
    dask
    dask-awkward
    dask-histogram
    fsspec-xrootd
    hist
    lz4
    matplotlib
    mplhep
    numba
    numpy
    packaging
    pandas
    pyarrow
    requests
    scipy
    toml
    tqdm
    uproot
    vector
  ] ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    distributed
    pyinstrument
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "coffea" ];

  disabledTests =
    [
      # Requires internet access
      # https://github.com/CoffeaTeam/coffea/issues/1094
      "test_lumimask"

      # Flaky: FileNotFoundError: [Errno 2] No such file or directory
      # https://github.com/scikit-hep/coffea/issues/1246
      "test_packed_selection_cutflow_dak" # cutflow.npz
      "test_packed_selection_nminusone_dak" # nminusone.npz

      # AssertionError: bug in Awkward Array: attempt to convert TypeTracerArray into a concrete array
      "test_apply_to_fileset"
      "test_lorentz_behavior"

      # ValueError: The array to mask was deleted before it could be masked.
      # If you want to construct this mask, you must either keep the array alive or use 'ak.mask' explicitly.
      "test_read_nanomc"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Fatal Python error: Segmentation fault
      # coffea/nanoevents/transforms.py", line 287 in index_range
      "test_KaonParent_to_PionDaughters_Loop"
      "test_MCRecoAssociations"
      "test_MC_daughters"
      "test_MC_parents"
      "test_field_is_present"

      # Fatal Python error: Segmentation fault
      # File "/build/source/tests/test_lumi_tools.py", line 37 in test_lumidata
      "test_lumidata"
      # coffea/lumi_tools/lumi_tools.py", line 113 in get_lumi
      "test_lumilist"
    ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Basic tools and wrappers for enabling not-too-alien syntax when running columnar Collider HEP analysis";
    homepage = "https://github.com/CoffeaTeam/coffea";
    changelog = "https://github.com/CoffeaTeam/coffea/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
