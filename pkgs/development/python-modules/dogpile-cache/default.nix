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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "dogpile_cache";
    inherit version;
    hash = "sha256-sAqeL0Cc+b9Iwuej4+aNrF+nWROsvxpi+CfIEtNfPQk=";
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

  meta = {
    description = "Caching front-end based on the Dogpile lock";
    homepage = "https://github.com/sqlalchemy/dogpile.cache";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
