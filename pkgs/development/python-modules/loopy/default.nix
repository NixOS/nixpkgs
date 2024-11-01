{
  lib,
  buildPythonPackage,
  codepy,
  cgen,
  colorama,
  fetchFromGitHub,
  genpy,
  immutables,
  islpy,
  mako,
  numpy,
  pymbolic,
  pyopencl,
  pyrsistent,
  pythonOlder,
  pytools,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "loopy";
  version = "2024.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "loopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-mU8vXEPR88QpJpzXZlZdDhMtlwIx5YpeYhXU8Vw2T9g=";
    fetchSubmodules = true; # submodule at `loopy/target/c/compyte`
  };

  build-system = [ setuptools ];

  dependencies = [
    codepy
    cgen
    colorama
    genpy
    immutables
    islpy
    mako
    numpy
    pymbolic
    pyopencl
    pyrsistent
    pytools
    typing-extensions
  ];

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "loopy" ];

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  doCheck = false;

  meta = {
    description = "Code generator for array-based code on CPUs and GPUs";
    homepage = "https://github.com/inducer/loopy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
