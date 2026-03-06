{
  lib,
  stdenv,
  buildPythonPackage,
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
}:

buildPythonPackage (finalAttrs: {
  pname = "loopy";
  version = "2025.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "loopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VgsUOMCIg61mYNDMcGpMs5I1CkobhUFVjoQFdD8Vchs=";
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

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  doCheck = false;

  meta = {
    description = "Code generator for array-based code on CPUs and GPUs";
    homepage = "https://github.com/inducer/loopy";
    changelog = "https://github.com/inducer/loopy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
