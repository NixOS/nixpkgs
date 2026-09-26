{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "daff";
  version = "1.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-R/A5Htp+K1AR98ysAGuReKzLRlvLlKLJ8oQlf/9dJoY=";
  };

  build-system = [ setuptools ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "daff" ];

  meta = {
    description = "Library for comparing tables, producing a summary of their differences, and using such a summary as a patch file";
    homepage = "https://github.com/paulfitz/daff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ turion ];
  };
})
