{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  setuptools,
}:
buildPythonPackage rec {
  pname = "comfyui-workflow-templates";
  version = "0.1.95";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "workflow_templates";
    rev = "v${version}";
    hash = "sha256-apEMYNTccMXIQ852Lt/edVNfme8diX20nfUEp9ofgso=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "comfyui_workflow_templates" ];

  # TODO: identify why this isn't already included by setuptools
  postInstall = ''
    mv ./templates $out/${python.sitePackages}/comfyui_workflow_templates/
  '';

  meta = {
    description = "Official front-end implementation of ComfyUI";
    homepage = "https://github.com/Comfy-Org/ComfyUI_frontend/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
