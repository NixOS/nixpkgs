{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "random2";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-N1T870gmdWfNVwX6faa7w4Ccs/gIdAMT5nBazDwFfnc=";
  };
  patches = [
    ./tests-exit-code.patch
    ./tests-pypy-skip-bigrand.patch
  ];

  build-system = [ setuptools ];

  checkPhase = ''
    ${python.interpreter} src/tests.py
  '';

  meta = {
    homepage = "http://pypi.org/pypi/random2/";
    changelog = "https://github.com/strichter/random2/blob/${finalAttrs.version}/CHANGES.rst";
    description = "Python 3 compatible Python 2 `random` Module";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
})
