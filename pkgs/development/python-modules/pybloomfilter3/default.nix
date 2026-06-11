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
  pname = "pybloomfilter3";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cavoq";
    repo = "pybloomfiltermmap3";
    rev = "237631c181423c42043ba8003a305dd1d8e0b700"; # repo has no tags or branches
    hash = "sha256-vUaU0U5Smmm+k+i54uKu/R2qpoCbdq3LrjU4/BBEMq8=";
  };

  build-system = [
    setuptools
    cython
  ];

  # tests are not discovered by pytestCheckHook
  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    runHook preCheck
    python -m unittest discover -s tests -p "*.py"
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/prashnts/pybloomfilter3/blob/${finalAttrs.src.rev}/CHANGELOG";
    description = "Fast Python Bloom Filter using Mmap";
    homepage = "https://github.com/prashnts/pybloomfilter3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
})
