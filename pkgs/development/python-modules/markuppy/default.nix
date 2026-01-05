{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "markuppy";
  version = "1.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VA8xuDUHYmAzk2iJCsT0TrOXHXX9vZe0n6H4tmhVE9M=";
  };

  build-system = [ setuptools ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "MarkupPy" ];

  meta = with lib; {
    description = "HTML/XML generator";
    homepage = "https://github.com/tylerbakke/MarkupPy";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
