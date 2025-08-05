{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pytest-localserver,
  numpy,
  pillow,
  pydicom,
  requests,
  retrying,
}:

buildPythonPackage rec {
  pname = "dicomweb-client";
  version = "0.60.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "dicomweb-client";
    tag = "v${version}";
    hash = "sha256-ZxeZiCw8I5+Bf266PQ6WQA8mBRC7K3/kZrmuW4l6kQU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pillow
    pydicom
    requests
    retrying
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-localserver
  ];

  pythonImportsCheck = [ "dicomweb_client" ];

  meta = with lib; {
    description = "Python client for DICOMweb RESTful services";
    homepage = "https://dicomweb-client.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/dicomweb-client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "dicomweb_client";
  };
}
