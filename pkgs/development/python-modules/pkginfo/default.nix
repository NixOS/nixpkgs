{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkginfo";
  version = "1.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-itkaBEWgNngrk2bvi4wsUCkfg6VTR4uoWAxz0yFXAM8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # wheel metadata version mismatch 2.1 vs 2.3
    "test_installed_ctor_w_dist_info"
  ];

  pythonImportsCheck = [ "pkginfo" ];

  meta = {
    changelog = "https://pypi.org/project/pkginfo/#pkginfo-changelog";
    description = "Query metadatdata from sdists, bdists or installed packages";
    mainProgram = "pkginfo";
    homepage = "https://code.launchpad.net/~tseaver/pkginfo";
    longDescription = ''
      This package provides an API for querying the distutils metadata
      written in the PKG-INFO file inside a source distriubtion (an sdist)
      or a binary distribution (e.g., created by running bdist_egg). It can
      also query the EGG-INFO directory of an installed distribution, and the
      *.egg-info stored in a “development checkout” (e.g, created by running
      setup.py develop).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
