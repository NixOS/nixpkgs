{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  bluez,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  dbus-fast,
  pyobjc-core,
  pyobjc-framework-CoreBluetooth,
  pyobjc-framework-libdispatch,
  typing-extensions,
  async-timeout,

  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = "bleak";
    tag = "v${version}";
    hash = "sha256-UrKJoEyLa75HMCOgxmOqJi1z+32buMra+dwVe5qbBds=";
  };

  postPatch =
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace bleak/backends/bluezdbus/version.py \
        --replace-fail \
          '"bluetoothctl"' \
          '"${lib.getExe' bluez "bluetoothctl"}"'
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
