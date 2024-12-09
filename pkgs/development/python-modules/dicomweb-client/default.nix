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
  version = "0.59.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-D3j5EujrEdGTfR8/V3o2VJ/VkGdZ8IifPYMhP4ppXhw=";
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
    changelog = "https://github.com/ImagingDataCommons/dicomweb-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "dicomweb_client";
  };
}
