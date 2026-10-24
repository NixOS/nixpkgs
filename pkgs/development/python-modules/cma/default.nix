{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # optional-dependencies
  matplotlib,
  scipy,

  # tests
  python,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cma";
  version = "4.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    tag = "r${finalAttrs.version}";
    hash = "sha256-54atJuPFTczLN4piSLh84+W0GKJ1u/LgurZZpRrQZe4=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  optional-dependencies = {
    plotting = [ matplotlib ];
    statistical-tests = [ scipy ];
  };

  pythonImportsCheck = [ "cma" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  checkPhase = ''
    runHook preCheck

    ${python.executable} -m cma.test

    runHook postCheck
  '';

  meta = {
    description = "Library for Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization";
    homepage = "https://github.com/CMA-ES/pycma";
    changelog = "https://github.com/CMA-ES/pycma/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
