{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bundlewrap,
  passlib,
  requests,
}:

buildPythonPackage rec {
  pname = "bundlewrap-teamvault";
  version = "3.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kwJnfPMIhQsahIZFVtFb/YFgMUrnDt8t8+eJrig/ZTU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bundlewrap
    passlib
    requests
  ];

  # upstream has no checks
  doCheck = false;

  pythonImportsCheck = [ "bwtv" ];

  meta = with lib; {
    homepage = "https://github.com/trehn/bundlewrap-teamvault";
    description = "Pull secrets from TeamVault into your BundleWrap repo";
    license = [ licenses.gpl3 ];
    maintainers = [ ];
  };
}
