{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  setuptools,
}:
let
  version = "0.9.4";
  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "workflow_templates";
    rev = "v${version}";
    hash = "sha256-d78HMrQtKzUHGsYfaaJbIrIe/FhV3VBxFR4g8cQC5vE=";
  };

  # TODO: cleanup, de-dupe
  mkWorkflow = suffix: subdir: buildPythonPackage rec {
    pname = "comfyui-workflow-templates-${suffix}";
    inherit version src;
    pyproject = true;

    build-system = [ setuptools ];

    sourceRoot = "${src.name}/packages/${subdir}";

    pythonImportsCheck = [ "comfyui_workflow_templates_${subdir}" ];

    meta = {
      # description = "Official front-end implementation of ComfyUI";
      # homepage = "https://github.com/Comfy-Org/ComfyUI_frontend/";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        jk
      ];
    };
  };

  subPackages = {
    "core" = mkWorkflow "core" "core";
    "media_api" = mkWorkflow "media_api" "media_api";
    "media_image" = mkWorkflow "media_image" "media_image";
    "media_video" = mkWorkflow "media_video" "media_video";
    "media_other" = mkWorkflow "media_other" "media_other";
  };
in
buildPythonPackage rec {
  pname = "comfyui-workflow-templates";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "workflow_templates";
    rev = "v${version}";
    hash = "sha256-d78HMrQtKzUHGsYfaaJbIrIe/FhV3VBxFR4g8cQC5vE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = lib.attrValues subPackages;

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
