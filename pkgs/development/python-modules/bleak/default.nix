{
  lib,
  stdenv,
  async-timeout,
  bluez,
  buildPythonPackage,
  dbus-fast,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
  pyobjc-core,
  pyobjc-framework-CoreBluetooth,
  pyobjc-framework-libdispatch,
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = "bleak";
    tag = "v${version}";
    hash = "sha256-z0Mxr1pUQWNEK01PKMV/CzpW+GeCRcv/+9BADts1FuU=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/version.py \
      --replace-fail \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  build-system = [ poetry-core ];

  dependencies = [
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus-fast
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pyobjc-core
    pyobjc-framework-CoreBluetooth
    pyobjc-framework-libdispatch
  ]
  ++ lib.optionals (pythonOlder "3.12") [
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak" ];

  meta = {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    changelog = "https://github.com/hbldh/bleak/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
