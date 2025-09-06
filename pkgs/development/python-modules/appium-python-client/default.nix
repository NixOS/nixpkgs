{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  selenium,
}:

buildPythonPackage rec {
  pname = "Appium-Python-Client";
  version = "5.2.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    rev = "v${version}";
    sha256 = "sha256-UGScbfFde0z5Bsll5VYyA1J+xv53c+uMBKU3hJztnL0=";
  };

  build-system = [ hatchling ];

  buildInputs = [
    selenium
  ];

  pythonImportsCheck = [ "appium" ];

  meta = {
    description = "Python language bindings for Appium";
    homepage = "https://appium.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
