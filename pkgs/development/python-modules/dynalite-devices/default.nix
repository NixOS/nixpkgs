{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dynalite-devices";
  version = "0.47";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ziv1234";
    repo = "python-dynalite-devices";
    rev = "refs/tags/v${version}";
    hash = "sha256-kJo4e5vhgWzijLUhQd9VBVk1URpg9SXhOA60dJYashM=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "dynalite_devices_lib"
  ];

  meta = with lib; {
    description = "An unofficial Dynalite DyNET interface creating devices";
    homepage = "https://github.com/ziv1234/python-dynalite-devices";
    changelog = "https://github.com/ziv1234/python-dynalite-devices/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
