{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,

  # dependencies
  pytools,
  pymbolic,
  genpy,
  numpy,
  cgen,
  islpy,
  codepy,
  colorama,
  mako,
  constantdict,
  typing-extensions,

  # optional-dependencies
  pyopencl,
  fparser,
  ply,

  # check
  pocl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loopy";
  version = "2025.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "loopy";
    tag = "v${version}";
    hash = "sha256-3Ebnje+EBw2Jdp2xLqffWx592OoUrSdRDXQkw6FpEzc=";
    fetchSubmodules = true; # submodule at `loopy/target/c/compyte`
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [
    pytools
    pymbolic
    genpy
    numpy
    cgen
    islpy
    codepy
    colorama
    mako
    constantdict
    typing-extensions
  ];

  optional-dependencies = {
    pyopencl = [
      pyopencl
    ];
    fortran = [
      fparser
      ply
    ];
  };

  pythonImportsCheck = [ "loopy" ];

  nativeCheckInputs = [
    pocl
    pytestCheckHook
  ] ++ optional-dependencies.pyopencl;

  disabledTests = [
    # Fatal Python error: Illegal instruction on some cpus
    "test_apps"
    # test_axpy stuck
    "test_axpy"
    # https://github.com/inducer/loopy/issues/718
    "test_local_parallel_scan"
    "test_argmax"
  ];

  meta = {
    description = "Code generator for array-based code on CPUs and GPUs";
    homepage = "https://github.com/inducer/loopy";
    changelog = "https://github.com/inducer/loopy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
