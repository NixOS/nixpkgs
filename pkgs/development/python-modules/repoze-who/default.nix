{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  webob,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "repoze-who";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "repoze";
    repo = "repoze.who";
    tag = version;
    hash = "sha256-/Z+jbytIL5zZhNJ3B7HC9lDkK8pDwXu+gjxHPdnm890=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    webob
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "repoze.who" ];

  pythonNamespaces = [
    "repoze"
    "repoze.who"
    "repoze.who.plugins"
  ];

  meta = {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    changelog = "https://github.com/repoze/repoze.who/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
