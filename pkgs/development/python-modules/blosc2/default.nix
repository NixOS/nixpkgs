{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  cmake,
  cython,
  ninja,
  pkg-config,
  scikit-build-core,

  # native dependencies
  c-blosc2,

  # dependencies
  msgpack,
  ndindex,
  numexpr,
  numpy,
  httpx,
  threadpoolctl,
  pydantic,
  rich,

  # optional dependencies
  fsspec,
  h5py,
  hdf5plugin,
  matplotlib,
  pillow,
  pyarrow,
  textual,
  textual-image,
  textual-plotext,
  zarr,

  # tests
  psutil,
  pytestCheckHook,
  pytest-asyncio,
  pytest-xdist,
  torch,
  aiohttp,
  requests,
  runTorchTests ? lib.meta.availableOn stdenv.hostPlatform torch,
}:

let
  yyjsonRev = "8b4a38dc994a110abaec8a400615567bd996105f";
  sleefRev = "7623d6cfa2712462880fa63a4d0f0b5f775d1a83";
  miniexprRev = "daa302b748381fe8ddd7e77681757f34e9b071d9";
  tinyccRev = "ffbb8ebff5586b89f545826142a911a932b95315";
in
buildPythonPackage rec {
  pname = "blosc2";
  version = "4.16.0";
  pyproject = true;

  srcs = [
    (fetchFromGitHub {
      owner = "Blosc";
      repo = "python-blosc2";
      tag = "v${version}";
      hash = "sha256-VWv6X72+msqt4wlI+/dPIoClvf9mVcwBeTezk5ZbZ4w=";
    })
    (fetchFromGitHub {
      name = "miniexpr";
      owner = "Blosc";
      repo = "miniexpr";
      rev = miniexprRev;
      hash = "sha256-uDUbHJcT8NgPboUG1FiaTYg9w3yDQd9vgZwI3xpg5KY=";
    })
    (fetchFromGitHub {
      name = "sleef";
      owner = "shibatch";
      repo = "sleef";
      rev = sleefRev;
      hash = "sha256-a0OB2gQI8RlR7liXdlOZo4xDl3f2p9thrCm8CwD2jRM=";
    })
    (fetchFromGitHub {
      name = "tinycc";
      owner = "Blosc";
      repo = "minicc";
      rev = tinyccRev;
      hash = "sha256-177sul+ZYx5+RSi5uN+tRC4XgyPRDAmT2zWjqmnAxy0=";
    })
    (fetchFromGitHub {
      name = "yyjson";
      owner = "ibireme";
      repo = "yyjson";
      rev = yyjsonRev;
      hash = "sha256-1CYnEgUMUc7eqdkv6M/KyL/MdVQBMov9HgLCycF6++w=";
    })
  ];
  sourceRoot = "source";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  # perform parameter expansion for CMAKE_ARGS
  preUnpack =
    let
      cmakeArgs = toString [
        (lib.cmakeBool "USE_SYSTEM_BLOSC2" true)
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINIEXPR" "$PWD/miniexpr")
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SLEEF" "$PWD/sleef")
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYCC" "$PWD/tinycc")
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YYJSON" "$PWD/yyjson")
      ];
    in
    ''
      export CMAKE_ARGS="${cmakeArgs}"
    '';
  postUnpack = ''
    # ensure our separately pinned versions correspond to those in source
    if ! grep -F '${miniexprRev}' source/CMakeLists.txt ; then
      echo 'Expected to find ${miniexprRev} in source/CMakeLists.txt:' \
        'has miniexpr source been updated to match pinned version?'
      exit 1
    fi
    if ! grep -F '${sleefRev}' miniexpr/cmake/MiniexprFetchDeps.cmake ; then
      echo 'Expected to find ${sleefRev} in miniexpr/cmake/MiniexprFetchDeps.cmake:' \
        'has sleef source been updated to match pinned version?'
      exit 1
    fi
    if ! grep -F '${tinyccRev}' miniexpr/cmake/MiniexprFetchDeps.cmake ; then
      echo 'Expected to find ${tinyccRev} in miniexpr/cmake/MiniexprFetchDeps.cmake:' \
        'has tinycc source been updated to match pinned version?'
      exit 1
    fi
    if ! grep -F '${yyjsonRev}' miniexpr/cmake/MiniexprFetchDeps.cmake ; then
      echo 'Expected to find ${yyjsonRev} in miniexpr/cmake/MiniexprFetchDeps.cmake:' \
        'has yyjson source been updated to match pinned version?'
      exit 1
    fi
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    cython
    numpy
    scikit-build-core
  ];

  buildInputs = [ c-blosc2 ];

  dependencies = [
    msgpack
    ndindex
    numexpr
    numpy
    threadpoolctl
    pydantic
    rich
    httpx
  ]
  ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    aiohttp
    requests
    psutil
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    h5py
    pyarrow
    textual
    textual-plotext
  ]
  ++ lib.optionals runTorchTests [ torch ];

  disabledTestMarks = [
    "network"
    "heavy"
  ];

  disabledTests = [
    # attempts external network requests
    "test_with_remote"
    # segfaults, but only under nix sandbox
    "test_dsl_save_clamp"
    # we don't appear to have the jit working in the sandbox yet
    "test_evaluation_time_and_udf_policy"
    "test_auto_and_configured_routes_are_distinct"
    "test_tcc_no_cache_directory"
    "test_tcc_invalid_tmpdir"
    "test_menudet_loader_options"
    # flaky
    "test_parallel_metadata_benchmark"
    "test_remote_table_startup_and_reload_keep_content_stable"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/Blosc/python-blosc2/issues/551
    "test_expand_dims"
  ];

  # otherwise attempts to find package files for doctests
  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # Threads grow without limit
    # https://github.com/Blosc/python-blosc2/issues/556
    "tests/ndarray/test_lazyexpr.py"
    "tests/ndarray/test_lazyexpr_fields.py"
    "tests/ndarray/test_reductions.py"
  ];

  optional-dependencies = rec {
    fsspec = [
      fsspec
      fsspec.optional-dependencies.http
    ];
    hdf5 = [
      h5py
      hdf5plugin
    ];
    images = tui ++ [
      textual-image
      pillow
    ];
    hires = images ++ [
      matplotlib
    ];
    parquet = [ pyarrow ];
    tui = [
      textual
      textual-plotext
    ];
    zarr = [ zarr ];
  };

  passthru.c-blosc2 = c-blosc2;

  meta = {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/${(builtins.head srcs).name}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ris ];
  };
}
