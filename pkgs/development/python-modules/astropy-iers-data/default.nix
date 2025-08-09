{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "astropy-iers-data";
  version = "0.2025.3.31.0.36.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    tag = "v${version}";
    hash = "sha256-51U5QStpzTGwg1MC1NJPMnothjF3Aa7j3dxiRUfnqDE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "astropy_iers_data" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
