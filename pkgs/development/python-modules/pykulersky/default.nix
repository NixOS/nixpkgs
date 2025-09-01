{
  lib,
  bleak,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykulersky";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "pykulersky";
    rev = version;
    hash = "sha256-YHGEDAsbQN3sYu7mdVUbb3xX7FMnR0xAhXkvf7Ok7qs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    click
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pykulersky" ];

  meta = with lib; {
    description = "Python module to control Brightech Kuler Sky Bluetooth LED devices";
    mainProgram = "pykulersky";
    homepage = "https://github.com/emlove/pykulersky";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
