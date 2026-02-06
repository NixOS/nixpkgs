{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  selenium,
}:

buildPythonPackage rec {
  pname = "appium-python-client";
  version = "5.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    tag = "v${version}";
    sha256 = "sha256-BrKIZR8n5ZiOfGAxgCtt5FwPbbOtlPfMqW91HKjP5ro=";
  };

  build-system = [ hatchling ];

  dependencies = [
    selenium
  ];

  pythonImportsCheck = [ "appium" ];

  meta = {
    description = "Cross-platform automation framework for all kinds of apps, built on top of the W3C WebDriver protocol";
    homepage = "https://appium.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
