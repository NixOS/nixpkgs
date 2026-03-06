{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  selenium,
}:

buildPythonPackage (finalAttrs: {
  pname = "appium-python-client";
  version = "5.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTbz2ncCl6C2QBCLMaIZn4fv/ib/IvkWoRSrlxuFauM=";
  };

  build-system = [ hatchling ];

  dependencies = [ selenium ];

  pythonImportsCheck = [ "appium" ];

  meta = {
    description = "Cross-platform automation framework for all kinds of apps, built on top of the W3C WebDriver protocol";
    homepage = "https://appium.io/";
    changelog = "https://github.com/appium/python-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
})
