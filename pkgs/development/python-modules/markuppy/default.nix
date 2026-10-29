{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "markuppy";
  version = "1.18";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VA8xuDUHYmAzk2iJCsT0TrOXHXX9vZe0n6H4tmhVE9M=";
  };

  build-system = [ setuptools ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "MarkupPy" ];

  meta = {
    description = "HTML/XML generator";
    homepage = "https://github.com/tylerbakke/MarkupPy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
})
