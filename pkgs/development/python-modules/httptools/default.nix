{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ayoy8Y2X4W6Qgn16gZ/6jb2MwkX8Th+p0QlbVO9L2Zk=";
  };

  # Tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];

  meta = {
    description = "Collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    changelog = "https://github.com/MagicStack/httptools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
