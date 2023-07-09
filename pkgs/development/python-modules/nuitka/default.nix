{ lib
, buildPythonPackage
, ccache
, fetchFromGitHub
, isPyPy
, ordered-set
, python
, setuptools
, zstandard
}:

buildPythonPackage rec {
  pname = "nuitka";
  version = "1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Nuitka";
    repo = "Nuitka";
    rev = version;
    hash = "sha256-2meOFL2agQn9eBPy3pN6VoNmzUkYZen4XLYO5cnD2kQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ordered-set
    zstandard
  ];

  nativeCheckInputs = [
    ccache
  ];

  postPatch = ''
    patchShebangs tests/run-tests
  '';

  checkPhase = ''
    runHook preCheck

    # ./tests/run-tests takes too long to run
    # basic test gives sufficient coverage to assume that a change is correct
    # https://nuitka.net/doc/developer-manual.html#basic-tests
    ${python.interpreter} tests/basics/run_all.py search

    runHook postCheck
  '';

  pythonImportsCheck = [
    "nuitka"
  ];

  # Requires CPython
  disabled = isPyPy;

  meta = with lib; {
    description = "Python compiler with full language support and CPython compatibility";
    license = licenses.asl20;
    homepage = "https://nuitka.net/";
    changelog = "https://github.com/Nuitka/Nuitka/blob/${src.rev}/Changelog.rst";
  };

}
