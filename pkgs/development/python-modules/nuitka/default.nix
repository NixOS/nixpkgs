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
  version = "2.7.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-qkA08uuJDow1h2SNzVIRtb32Qv06CzI/jH/2wGRwz/U=";
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
    license = licenses.asl20;
    homepage = "https://nuitka.net/";
  };
}
