{
  lib,
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
  version = "2.6.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-zHXSfR5d0qgy0q9nGvbI1ZrwzDytD5YceskShpArCw4=";
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

  meta = with lib; {
    description = "Python compiler with full language support and CPython compatibility";
    homepage = "https://nuitka.net/";
    license = licenses.asl20;
    changelog = "https://github.com/Nuitka/Nuitka/releases/tag/${version}";
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
