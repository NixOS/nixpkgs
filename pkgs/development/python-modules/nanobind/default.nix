{
  lib,
  stdenv,
  apple-sdk_11,
  buildPythonPackage,
  darwinMinVersionHook,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cmake,
  ninja,
  pathspec,
  scikit-build-core,

  # dependencies
  eigen,

  # tests
  pytestCheckHook,
  numpy,
  scipy,
  torch,
  tensorflow-bin,
  jax,
  jaxlib,
}:
buildPythonPackage rec {
  pname = "nanobind";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    tag = "v${version}";
    hash = "sha256-9OpDsjFEeJGtbti4Q9HHl78XaGf8M3lG4ukvHCMzyMU=";
    fetchSubmodules = true;
  };

  disabled = pythonOlder "3.8";

  build-system = [
    cmake
    ninja
    pathspec
    scikit-build-core
  ];

  dependencies = [ eigen ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.13 or newer
    (darwinMinVersionHook "10.13")

    apple-sdk_11
  ];

  dontUseCmakeBuildDir = true;

  preCheck = ''
    # TODO: added 2.2.0, re-enable on next bump
    # https://github.com/wjakob/nanobind/issues/754
    # "generated stubs do not match their references"
    # > -import tensorflow.python.framework.ops
    # > +import tensorflow
    rm tests/test_ndarray_ext.pyi.ref

    # build tests
    make -j $NIX_BUILD_CORES
  '';

  nativeCheckInputs =
    [
      pytestCheckHook
      numpy
      scipy
      torch
    ]
    ++ lib.optionals (!(builtins.elem stdenv.hostPlatform.system tensorflow-bin.meta.badPlatforms)) [
      tensorflow-bin
      jax
      jaxlib
    ];

  meta = {
    homepage = "https://github.com/wjakob/nanobind";
    changelog = "https://github.com/wjakob/nanobind/blob/${src.tag}/docs/changelog.rst";
    description = "Tiny and efficient C++/Python bindings";
    longDescription = ''
      nanobind is a small binding library that exposes C++ types in Python and
      vice versa. It is reminiscent of Boost.Python and pybind11 and uses
      near-identical syntax. In contrast to these existing tools, nanobind is
      more efficient: bindings compile in a shorter amount of time, produce
      smaller binaries, and have better runtime performance.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ parras ];
  };
}
