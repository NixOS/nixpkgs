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
    hash = "sha256-/Nxvfmxopq1TzASOS8o8lDKY+wqZuw6cfmAlvEaGOg0=";
  };

  # TODO: cleanup, de-dupe
  mkWorkflow = suffix: subdir: buildPythonPackage rec {
    pname = "comfyui-workflow-templates-${suffix}";
    inherit version src;
    pyproject = true;

    build-system = [
      setuptools
    ];

    sourceRoot = "${src.name}/packages/${subdir}";

  # TODO: just copying all templates to all subpackages for now
  # don't really want to provide nx javascript tool and faff about
  postInstall = ''
    cp -r ../../templates $out/${python.sitePackages}/comfyui_workflow_templates_${subdir}/
  '';

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
  version = "0.9.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "workflow_templates";
    rev = "v${version}";
    hash = "sha256-/Nxvfmxopq1TzASOS8o8lDKY+wqZuw6cfmAlvEaGOg0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = lib.attrValues subPackages;

  pythonImportsCheck = [ "comfyui_workflow_templates" ];

  # TODO: identify why this isn't already included by setuptools
  postInstall = ''
    cp -r ./templates $out/${python.sitePackages}/comfyui_workflow_templates/
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
