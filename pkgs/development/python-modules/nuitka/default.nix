{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  appdirs,
  jinja2,
  pyyaml,
  tqdm,
  zstandard,

  # tests
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "nuitka";
  version = "4.0.8";
  pyproject = true;

  disabled =
    # Requires CPython
    isPyPy
    # Test failures
    || (pythonAtLeast "3.14");

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    tag = finalAttrs.version;
    hash = "sha256-f12FAItua3VASk2ipesQEalWYREpXidl7Jo3URczf9g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    appdirs
    jinja2
    pyyaml
    tqdm
    zstandard
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/basics/run_all.py search

    runHook postCheck
  '';

  pythonImportsCheck = [ "nuitka" ];

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
