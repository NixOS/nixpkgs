{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flake8,
  six,
  python,
}:

buildPythonPackage rec {
  pname = "flake8-future-import";
  version = "0.4.7";
  pyproject = true;

  # PyPI tarball doesn't include the test suite
  src = fetchFromGitHub {
    owner = "xZise";
    repo = "flake8-future-import";
    tag = version;
    hash = "sha256-2EcCOx3+PCk9LYpQjHCFNpQVI2Pdi+lWL8R6bNadFe0=";
  };

  patches = [
    ./fix-annotations-version-11.patch
  ];

  postPatch = ''
    substituteInPlace "test_flake8_future_import.py" \
      --replace-fail "'flake8'" "'${lib.getExe flake8}'"
  '';

  build-system = [ setuptools ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ six ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m test_flake8_future_import

    runHook postCheck
  '';

  meta = {
    description = "Flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    homepage = "https://github.com/xZise/flake8-future-import";
    license = lib.licenses.mit;
  };
}
