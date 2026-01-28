{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,

  # build-system
  setuptools,

  # dependencies
  ordered-set,
  zstandard,

  # tests
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "nuitka";
  version = "2.8.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    tag = finalAttrs.version;
    hash = "sha256-+CevWpYvqY3SX3/QE7SPlbsFtXkdlNTg9m91VtZCHvM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ordered-set
    zstandard
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/basics/run_all.py search

    runHook postCheck
  '';

  pythonImportsCheck = [ "nuitka" ];

  # Requires CPython
  disabled = isPyPy;

  meta = {
    description = "Python compiler with full language support and CPython compatibility";
    license = lib.licenses.asl20;
    homepage = "https://nuitka.net/";
    downloadPage = "https://github.com/Nuitka/Nuitka";
    changelog = "https://nuitka.net/changelog/Changelog.html";
    badPlatforms = [
      # never built on darwin since first introduction in nixpkgs
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
