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
  runTorchTests ? lib.meta.availableOn stdenv.hostPlatform torch,
}:

let
  sleefRev = "7623d6cfa2712462880fa63a4d0f0b5f775d1a83";
  miniexprRev = "f0b8c94771cd21d3c9029d6ccec204ab3a67584f";
  tinyccRev = "695ad1e6b5c9a00875192ca1f3a9c4949dee4858";
in
buildPythonPackage rec {
  pname = "blosc2";
  version = "4.14.1";
  pyproject = true;

  srcs = [
    (fetchFromGitHub {
      owner = "Blosc";
      repo = "python-blosc2";
      tag = "v${version}";
      hash = "sha256-SZMsRGkg2Xqo6eKCxwsNWGteeUnM4KtT5Z/0CS0QDPI=";
    })
    (fetchFromGitHub {
      name = "miniexpr";
      owner = "Blosc";
      repo = "miniexpr";
      rev = miniexprRev;
      hash = "sha256-s84xa/94CHq7bu6mw9XU7Q8TfmSFpdhpLxHOG1XrMu4=";
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
      hash = "sha256-qLomeOAw0ipIJOo8/GtBEa1ZsjVtEDlb3/ph7uMcsZk=";
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
    hires = tui ++ [
      matplotlib
      textual-image
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
