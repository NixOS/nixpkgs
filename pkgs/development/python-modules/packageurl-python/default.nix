{ buildPythonPackage, fetchPypi, lib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-86VSrHQxFs154lz7uMqPk4sG+RyipS3rqA8GoqcBB0k=";
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
