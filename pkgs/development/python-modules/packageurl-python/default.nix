{ buildPythonPackage, fetchPypi, lib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1D22r2o1AJnjLp4F5zcBPQQJKHt2H6WcWKA+VdvDZIo=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "packageurl" ];

  meta = with lib; {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}
