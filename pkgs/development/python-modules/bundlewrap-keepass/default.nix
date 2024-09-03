{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bundlewrap,
  pykeepass,
}:

buildPythonPackage rec {
  pname = "bundlewrap-keepass";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P41VtI8VIqSp1IXe7fzKDBGmmXmDLRm7v1qV1g35IC4";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bundlewrap
    pykeepass
  ];

  # upstream has no checks
  doCheck = false;

  pythonImportsCheck = [ "bwkeepass" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/bundlewrap-keepass";
    description = "Use secrets from keepass in your BundleWrap repo";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
