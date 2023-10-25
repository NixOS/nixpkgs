{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-ai-formrecognizer";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vV92TMQ4UpWJpOfSlVoioIg8fNzikc8UpToNkHnDQns=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.ai.formrecognizer" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Form Recognizer Client Library for Python";
    homepage = " https://github.com/Azure/azure-sdk-for-python ";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}

