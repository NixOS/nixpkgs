{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  mako,
  decorator,
  stevedore,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "dogpile_cache";
    inherit version;
    hash = "sha256-TwKVV19f3T9+E8hLqONmVpcdGGmiCBtHN+yZ7eN4qMA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    stevedore
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mako
  ];

  meta = with lib; {
    description = "Caching front-end based on the Dogpile lock";
    homepage = "https://github.com/sqlalchemy/dogpile.cache";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
