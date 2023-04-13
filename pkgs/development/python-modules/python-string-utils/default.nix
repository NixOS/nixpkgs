{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-string-utils";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3PkGCwPwdkfApgNAjciwP4B/O1SgXG4Z6xRGAlb6wMs=";
  };

  pythonImportsCheck = ["string_utils"];

  # tests are not available in pypi tarball
  doCheck = false;

  meta = with lib; {
    description = "A handy Python library to validate, manipulate and generate strings.";
    homepage = "https://github.com/daveoncode/python-string-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
