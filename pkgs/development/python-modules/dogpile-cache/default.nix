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
  version = "1.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "dogpile.cache";
    inherit version;
    hash = "sha256-+EuO0LD7KX0VEFVEf6jcr3uuVm1Nve/s3MHzdmKrWIs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
