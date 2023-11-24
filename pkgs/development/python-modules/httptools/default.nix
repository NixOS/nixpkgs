{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n8bkCa04y9aLF3zVFY/EBCx5a4LKiNmex48HvtbGt5Y=";
  };

  # Tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [
    "httptools"
  ];

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    changelog = "https://github.com/MagicStack/httptools/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
