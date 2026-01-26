{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build
  setuptools,
  cython,
  # check
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybloomfiltermmap3";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prashnts";
    repo = "pybloomfiltermmap3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rPeBVSrDeThB2BGKqqLDg7adsMmX6LBZULPP6RlYZUQ=";
  };

  build-system = [
    setuptools
    cython
  ];

  # tests are not discovered by pytestCheckHook
  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    runHook preCheck
    python -m tests
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/prashnts/pybloomfiltermmap3/blob/${finalAttrs.src.rev}/CHANGELOG";
    description = "Fast Python Bloom Filter using Mmap";
    homepage = "https://github.com/prashnts/pybloomfiltermmap3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
})
