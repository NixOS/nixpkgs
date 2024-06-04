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
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-nKdCMgA92v9VsSgfktXDbSh3DyKsGlcTjpn0Y7u4rxU=";
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
