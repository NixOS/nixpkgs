{
  lib,
  buildPythonPackage,
  fetchPypi,
  ssdeep,
  pefile,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyimpfuzzy";
  version = "0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "pyimpfuzzy";
    inherit (finalAttrs) version;
    hash = "sha256-2peW3zAttLBKGXEoY3+EmI8YgvHgj91pu/n9xs+680k=";
  };

  build-system = [ setuptools ];

  buildInputs = [ ssdeep ];

  dependencies = [ pefile ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pyimpfuzzy" ];

  meta = {
    description = "Python module which calculates and compares the impfuzzy (import fuzzy hashing)";
    homepage = "https://github.com/JPCERTCC/impfuzzy";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
