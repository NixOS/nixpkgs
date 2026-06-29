{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # dependencies
  click,
  distutils,

  # test dependencies
  coverage,
  pytestCheckHook,
  sure,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-man";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-man";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tHoswLw1/8gI3VlTpLOChc3BAKgoMfYVpdjOY9LaNWc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    distutils
    setuptools
  ];

  pythonImportsCheck = [
    "click_man"
    "click_man.core"
    "click_man.man"
  ];

  nativeCheckInputs = [
    coverage
    pytestCheckHook
    sure
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
