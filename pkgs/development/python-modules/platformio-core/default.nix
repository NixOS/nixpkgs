{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  bottle,
  click,
  colorama,
  pyelftools,
  pyserial,
  python-dateutil,
  requests,
  semantic-version,
  tabulate,
  urllib3,
}:

buildPythonPackage rec {
  pname = "platformio";
  version = "6.1.17";

  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    tag = "v${version}";
    hash = "sha256-01l39HXVm5Zu1uNQyrNxYx7Mk7kjzM329P/YC97kgjU=";
    fetchSubmodules = true;
  };

  pyproject = true;
  build-system = [ setuptools ];
  nativeBuildInputs = [
    wheel
  ];

  dependencies = [
    bottle
    click
    colorama
    pyelftools
    pyserial
    python-dateutil
    requests
    semantic-version
    tabulate
    urllib3
  ];

  pythonImportsCheck = [
    "platformio"
  ];

  meta = {
    homepage = "https://github.com/platformio/platformio-core";
    description = "Open source ecosystem for IoT development (CLI manager for embedded boards)";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jasonodoom ];
  };
}
