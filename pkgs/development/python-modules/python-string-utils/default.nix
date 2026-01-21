{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-string-utils";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3PkGCwPwdkfApgNAjciwP4B/O1SgXG4Z6xRGAlb6wMs=";
  };

  pythonImportsCheck = [ "string_utils" ];

  # tests are not available in pypi tarball
  doCheck = false;

  meta = {
    description = "Handy Python library to validate, manipulate and generate strings";
    homepage = "https://github.com/daveoncode/python-string-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
