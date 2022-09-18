{ buildPythonPackage, fetchPypi, lib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oBNxqQFftcGjxi6y9yULh9FzP87VfwdeMHFeuOFeB10=";
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
