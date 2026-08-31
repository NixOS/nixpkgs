{
  lib,
  buildPythonPackage,
  fetchPypi,

  cython,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G5PlPN22eg5PqjTWz5GaxsZi/rHIwO2QHXG1las5aqM=";
  };

  # remove dependency on pkg_resources
  # See: https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder/pull/99
  postPatch = ''
    substituteInPlace pyworld/__init__.py \
      --replace-fail "import pkg_resources" "import importlib.metadata" \
      --replace-fail "pkg_resources.get_distribution('pyworld').version" "importlib.metadata.version('pyworld')"
  '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "pyworld" ];

  meta = {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
}
