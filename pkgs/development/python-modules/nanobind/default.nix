{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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

  nanobind,
}:
buildPythonPackage rec {
  pname = "nanobind";
  version = "2.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-cC+sf2FUm1jdGMRdDoaQK8rjUVkWjn/53c1HQ5gsUWs=";
  };

  build-system = [
    cmake
    ninja
    pathspec
    scikit-build-core
  ];

  dependencies = [ eigen ];

  dontUseCmakeBuildDir = true;

  # nanobind check requires heavy dependencies such as tensorflow
  # which are less than ideal to be imported in children packages that
  # use it as build-system parameter.
  doCheck = false;

  preCheck = ''
    # build tests
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
    pytest = nanobind.overridePythonAttrs { doCheck = true; };
  };

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
