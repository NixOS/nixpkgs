{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mailchecker";
  version = "6.0.20";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lT4WxafcpOXbxJfInRjDx1x+mvZMBa7m0ASvr4oD64o=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "MailChecker" ];

  meta = {
    description = "Module for temporary (disposable/throwaway) email detection";
    homepage = "https://github.com/FGRibreau/mailchecker";
    changelog = "https://github.com/FGRibreau/mailchecker/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
