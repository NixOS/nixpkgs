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
  platformdirs,
  py-cpuinfo,
  requests,

  # tests
  psutil,
  pytestCheckHook,
  torch,
  runTorchTests ? lib.meta.availableOn stdenv.hostPlatform torch,
}:

let
  sleefRev = "7623d6cfa2712462880fa63a4d0f0b5f775d1a83";
  miniexprRev = "37bf6982bf9619036b47f095b7005bc3c87a7447";
  tinyccRev = "41208bdc85612042f363f425cda4601b3ed90d64";
in
buildPythonPackage rec {
  pname = "blosc2";
  version = "4.1.2";
  pyproject = true;

  srcs = [
    (fetchFromGitHub {
      owner = "Blosc";
      repo = "python-blosc2";
      tag = "v${version}";
      hash = "sha256-z5g3OXSKKR/2yQ5n1hb+br009xaX8C7HxbDDLVfSYNw=";
    })
    (fetchFromGitHub {
      name = "miniexpr";
      owner = "Blosc";
      repo = "miniexpr";
      rev = miniexprRev;
      hash = "sha256-3YLdAZFYEtmENuQgDiitU3kw8JmW+V03zFSGXV3FwqE=";
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
      hash = "sha256-lj0BC/A+Kv/VloLhFe3hmrdZ6QWv6mSrMn8HdHS9PfI=";
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
    if ! grep -F '${sleefRev}' miniexpr/CMakeLists.txt ; then
      echo 'Expected to find ${sleefRev} in miniexpr/CMakeLists.txt:' \
        'has sleef source been updated to match pinned version?'
      exit 1
    fi
    if ! grep -F '${tinyccRev}' miniexpr/CMakeLists.txt ; then
      echo 'Expected to find ${tinyccRev} in miniexpr/CMakeLists.txt:' \
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
    platformdirs
    py-cpuinfo
    requests
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ]
  ++ lib.optionals runTorchTests [ torch ];

  disabledTestMarks = [
    "network"
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

  disabledTestPaths = [
    # Threads grow without limit
    # https://github.com/Blosc/python-blosc2/issues/556
    "tests/ndarray/test_lazyexpr.py"
    "tests/ndarray/test_lazyexpr_fields.py"
    "tests/ndarray/test_reductions.py"
  ];

  passthru.c-blosc2 = c-blosc2;

  meta = {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/${(builtins.head srcs).name}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ris ];
  };
}
