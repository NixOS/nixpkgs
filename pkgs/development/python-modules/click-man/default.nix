{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyprojectVersionPatchHook,

  # build system
  setuptools,

  # dependencies
  click,

  # test dependencies
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-man";
  version = "0.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-man";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y5rWm5+C27P79E2NxaUaMTG96b1gJIor0k+3iTf0AT8=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    click
  ];

  pythonImportsCheck = [
    "click_man"
    "click_man.core"
    "click_man.man"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  meta = {
    changelog = "https://github.com/click-contrib/click-man/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Automate generation of man pages for python click applications";
    homepage = "https://github.com/click-contrib/click-man";
    license = lib.licenses.mit;
    mainProgram = "click-man";
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
