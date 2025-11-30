{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkginfo";
  version = "1.12.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XNlXgkrDbxQCYJZOujxr5kQqg1m4xI9K35AhDzOgS3s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # wheel metadata version mismatch 2.1 vs 2.2
    "test_get_metadata_w_module"
    "test_get_metadata_w_package_name"
    "test_installed_ctor_w_dist_info"
    "test_installed_ctor_w_name"
    "test_installed_ctor_w_package"
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
