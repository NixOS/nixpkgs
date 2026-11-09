{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  uv-dynamic-versioning,
  pytestCheckHook,
  pytest-localserver,
  numpy,
  pillow,
  pydicom,
  requests,
  retrying,
}:

buildPythonPackage (finalAttrs: {
  pname = "dicomweb-client";
  version = "0.61.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "dicomweb-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zFOnj8rzr2MUqcRFv9j7gXQHi9I7HwCmS1oNOKIkS5k=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

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

  meta = {
    description = "Python client for DICOMweb RESTful services";
    homepage = "https://dicomweb-client.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/dicomweb-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "dicomweb_client";
  };
})
