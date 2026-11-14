{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isFreeThreaded,

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

  nanobind_3,
}:
buildPythonPackage (finalAttrs: {
  pname = "nanobind";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-k7TIsx+BcOaZKC01cMs4ZqCWG2uWbx1TkilbMq1qkdI=";
  };

  build-system = [
    cmake
    ninja
    pathspec
    scikit-build-core
  ];

  dependencies = [ eigen ];

  dontUseCmakeBuildDir = true;

  # The cmake hook configures nanobind as the top-level project, which runs
  # find_package(Python). FindPython refuses a free-threaded interpreter
  # unless the fourth field (gil_disabled) of Python_FIND_ABI allows it.
  cmakeFlags = lib.optionals isFreeThreaded [
    (lib.cmakeFeature "Python_FIND_ABI" "ANY;ANY;ANY;ON")
  ];

  # nanobind check requires heavy dependencies such as tensorflow
  # which are less than ideal to be imported in children packages that
  # use it as build-system parameter.
  doCheck = false;

  # build tests
  preCheck = ''
    make -j $NIX_BUILD_CORES
  '';

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    scipy
    torch
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform tensorflow-bin) [
    tensorflow-bin
    jax
    jaxlib
  ];

  passthru.tests = {
    pytest = nanobind_3.overridePythonAttrs { doCheck = true; };
  };

  meta = {
    homepage = "https://github.com/wjakob/nanobind";
    changelog = "https://github.com/wjakob/nanobind/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Tiny and efficient C++/Python bindings";
    longDescription = ''
      nanobind is a small binding library that exposes C++ types in Python and
      vice versa. It is reminiscent of Boost.Python and pybind11 and uses
      near-identical syntax. In contrast to these existing tools, nanobind is
      more efficient: bindings compile in a shorter amount of time, produce
      smaller binaries, and have better runtime performance.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
