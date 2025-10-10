{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  zope-testing,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plone-testing";
  version = "9.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plone";
    repo = "plone.testing";
    tag = version;
    hash = "sha256-5DaN0o/EaWwdMvmLW12zdNXJ3p6dowALJ10zrhUT3dA=";
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
