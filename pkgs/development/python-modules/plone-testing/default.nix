{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  zope-testing,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plone-testing";
  version = "10.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plone";
    repo = "plone.testing";
    tag = version;
    hash = "sha256-6QjjshFIfV/w8cT63D/1RVIVauDsGJdy1PRncOYKxHY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    zope-testing
  ];

  pythonImportsCheck = [ "plone.testing" ];

  # Huge amount of testing dependencies (including Zope2)
  doCheck = false;

  pythonNamespaces = [ "plone" ];

  meta = {
    description = "Testing infrastructure for Zope and Plone projects";
    homepage = "https://github.com/plone/plone.testing";
    changelog = "https://github.com/plone/plone.testing/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
}
