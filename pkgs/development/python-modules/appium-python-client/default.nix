{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  selenium,
}:

buildPythonPackage rec {
  pname = "appium-python-client";
  version = "5.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    tag = "v${version}";
    sha256 = "sha256-oZquEwA1iNIVftt9XBdDfCoI3DLh7eM5/ATcrjJL+jA=";
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
