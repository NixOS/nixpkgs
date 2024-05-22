{
  lib,
  buildPythonPackage,
  ccache,
  fetchFromGitHub,
  isPyPy,
  ordered-set,
  python3,
  setuptools,
  zstandard,
  wheel,
}:

buildPythonPackage rec {
  pname = "nuitka";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-bV5zTYwhR/3dTM1Ij+aC6TbcPODZ5buwQi7xN8axZi0=";
  };

  # default lto off for darwin
  patches = [ ./darwin-lto.patch ];

  build-system = [
    setuptools
    wheel
  ];
  nativeCheckInputs = [ ccache ];

  dependencies = [
    ordered-set
    zstandard
  ];

  checkPhase = ''
    runHook preCheck

    ${python3.interpreter} tests/basics/run_all.py search

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
