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
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "dogpile_cache";
    inherit version;
    hash = "sha256-hJxVc8mjjxVc1BcxA8cCtjft4DYcEuhkh2h30M0SXuw=";
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
