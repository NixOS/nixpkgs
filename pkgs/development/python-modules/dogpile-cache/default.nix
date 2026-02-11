{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  mako,
  decorator,
  stevedore,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "dogpile_cache";
    inherit version;
    hash = "sha256-4lxg5nel4o/4YSR2X78YxTJXvNeDB0nNW6NQrOKhKYk=";
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
