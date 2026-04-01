{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  pytestCheckHook,
  xvfb,
}:

buildPythonPackage (finalAttrs: {
  pname = "sbvirtualdisplay";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdmintz";
    repo = "sbVirtualDisplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nQ77OKU/1Eif0mS1hF45YGfuFBVJeZ6kmQQnC0z/u0s=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    xvfb
  ];

  pythonImportsCheck = [ "sbvirtualdisplay" ];

  meta = {
    changelog = "https://github.com/mdmintz/sbVirtualDisplay/releases/tag/v${finalAttrs.version}";
    description = "Customized pyvirtualdisplay for use with SeleniumBase automation";
    homepage = "https://github.com/mdmintz/sbVirtualDisplay";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      pyrox0
    ];
  };
})
