{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n8bkCa04y9aLF3zVFY/EBCx5a4LKiNmex48HvtbGt5Y=";
  };

  # tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    license = licenses.mit;
    maintainers = [ ];
  };
}
