{ buildPythonPackage, fetchPypi, lib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-md8UOWC3EA//Oyz1sL66L2S22MgY9snxJa7W+sdDh2M=";
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
