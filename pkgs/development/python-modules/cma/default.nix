{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "cma";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    tag = "r${version}";
    hash = "sha256-2uCn5CZma9RLK8zaaPhiQCqnK+2dWgLNr5+Ck2cV6vI=";
  };

  # setuptools.errors.PackageDiscoveryError:
  # Multiple top-level packages discovered in a flat-layout: ['cma', 'notebooks'].
  postPatch = ''
    rm -rf notebooks
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "cma" ];

  # At least one doctest fails, thus only limited amount of files is tested
  checkPhase = ''
    ${python.executable} -m cma.test \
      interfaces.py \
      purecma.py \
      logger.py \
      optimization_tools.py \
      transformations.py
  '';

  meta = {
    description = "Library for Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization";
    homepage = "https://github.com/CMA-ES/pycma";
    changelog = "https://github.com/CMA-ES/pycma/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
