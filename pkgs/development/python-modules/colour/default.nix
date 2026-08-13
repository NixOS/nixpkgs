{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "colour";
  version = "0.1.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ryASD+/Sr+3osAH77y6p2nCtfUn6/bZIkCXa6HRcOu4=";
  };

  patches = [
    # https://github.com/vaab/colour/pull/66 (but does not merge cleanly)
    ./remove-unmaintained-d2to1.diff
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "--doctest-glob=*.rst"
    "--doctest-modules"
  ];

  pythonImportsCheck = [ "colour" ];

  meta = {
    description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
    homepage = "https://github.com/vaab/colour";
    license = lib.licenses.bsd2;
  };
})
