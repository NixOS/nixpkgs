{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  netifaces,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "greeclimate";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = "refs/tags/v${version}";
    hash = "sha256-M4oxFi/PpqhJgZX/wM+9rSrraIZcqzubbxnihfK0W2E=";
  };

  propagatedBuildInputs = [
    netifaces
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "greeclimate"
    "greeclimate.device"
    "greeclimate.discovery"
    "greeclimate.exceptions"
    "greeclimate.network"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Discover, connect and control Gree based minisplit systems";
    homepage = "https://github.com/cmroche/greeclimate";
    changelog = "https://github.com/cmroche/greeclimate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
