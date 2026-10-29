{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylru";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlhutch";
    repo = "pylru";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3qycUYmnLGiuNsrBOCL/QiRkrPVikaRqVBmQFURDGKs=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck

    python test.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "pylru" ];

  meta = {
    description = "Least recently used (LRU) cache implementation";
    homepage = "https://github.com/jlhutch/pylru";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
