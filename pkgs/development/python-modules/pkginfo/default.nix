{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pkginfo";
  version = "1.13.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rXTMgYSyi3ewbMzEk2H9D9xW/YfjB0Jc4cK3WW2+MYU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkginfo" ];

  meta = {
    changelog = "https://pypi.org/project/pkginfo/#pkginfo-changelog";
    description = "Query metadatdata from sdists, bdists or installed packages";
    mainProgram = "pkginfo";
    homepage = "https://code.launchpad.net/~tseaver/pkginfo";
    longDescription = ''
      This package provides an API for querying the distutils metadata
      written in the PKG-INFO file inside a source distribution (an sdist)
      or a binary distribution (e.g., created by running bdist_egg). It can
      also query the EGG-INFO directory of an installed distribution, and the
      *.egg-info stored in a “development checkout” (e.g, created by running
      setup.py develop).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
