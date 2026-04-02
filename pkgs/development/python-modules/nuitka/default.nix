{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  ordered-set,
  python,
  setuptools,
  zstandard,
  wheel,
}:

buildPythonPackage rec {
  pname = "nuitka";
  version = "4.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    tag = version;
    hash = "sha256-/JAwvsRqQZTAWG17mhbzW925kaMYEKCajKAFbWh7wBQ=";
  };

  build-system = [
    setuptools
    wheel
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
    # never built on darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
