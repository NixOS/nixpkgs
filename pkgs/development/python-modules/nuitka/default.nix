{ lib
, buildPythonPackage
, ccache
, fetchFromGitHub
, isPyPy
, ordered-set
, python3
, setuptools
, zstandard
}:

buildPythonPackage rec {
  pname = "nuitka";
  version = "1.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-spa3V9KEjqmwnHSuxLLIu9hJk5PrRwNyOw72sfxBVKo=";
  };

  # default lto off for darwin
  patches = [ ./darwin-lto.patch ];

  nativeBuildInputs = [ setuptools ];
  nativeCheckInputs = [ ccache  ];

  propagatedBuildInputs = [
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
