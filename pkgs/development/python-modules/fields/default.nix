{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fields";
  version = "5.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MdSqA9jUTjXfE8Qx3jUTaZfwR6kkpZfYT3vCCeG+Vyc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "fields" ];

  doCheck = false; # Argument(s) {'path'} are declared in the hookimpl but can not be found in the hookspec

  meta = {
    description = "Container class boilerplate killer";
    homepage = "https://github.com/ionelmc/python-fields";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
