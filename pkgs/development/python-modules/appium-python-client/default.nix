{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  selenium,
}:

buildPythonPackage (finalAttrs: {
  pname = "appium-python-client";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oZ0J35qX55U2pHa5LUpocKvSLIXAK06i68UYaTNruHM=";
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
