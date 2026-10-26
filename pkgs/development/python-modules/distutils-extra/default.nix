{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage (finalAttrs: {
  pname = "distutils-extra";
  version = "2.50";
  format = "setuptools";

  src = fetchurl {
    url = "https://salsa.debian.org/python-team/modules/python-distutils-extra/-/archive/${finalAttrs.version}/python-${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-aq5+JjlzD3fS4+CPxZNjyz2QNfqsChC0w6KRVgbTGwI=";
  };

  # Tests are out-dated as the last upstream release is from 2016
  doCheck = false;

  pythonImportsCheck = [ "DistUtilsExtra" ];

  meta = {
    description = "Enhancements to Python's distutils";
    homepage = "https://launchpad.net/python-distutils-extra";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
