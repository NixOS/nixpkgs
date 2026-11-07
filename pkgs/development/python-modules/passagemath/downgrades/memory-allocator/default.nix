{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  ...
}:
buildPythonPackage rec {
  name = "memory-allocator";
  version = "0.1.4";
  pyproject = true;

  build-system = [
    setuptools
    cython
  ];

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "memory_allocator";
    tag = "v${version}";
    hash = "sha256-lwZgMTIkgRorSHZhm5J0s4UmReAw6ENt354fWivs2hA=";
  };
}
