{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvdlib";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Vehemont";
    repo = "nvdlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VsI9benBDlqPyAbm3Vfto4MTF+9sPpWv37DtLJYkV/0=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "nvdlib" ];

  meta = {
    description = "Module to interact with the National Vulnerability CVE/CPE API";
    homepage = "https://github.com/Vehemont/nvdlib/";
    changelog = "https://github.com/vehemont/nvdlib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
