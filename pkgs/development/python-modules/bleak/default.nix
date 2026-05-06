{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  bluez,
  pythonOlder,

  # build-system
  uv-build,

  # dependencies
  bumble,
  dbus-fast,
  pyobjc-core,
  pyobjc-framework-CoreBluetooth,
  pyobjc-framework-libdispatch,
  typing-extensions,

  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = "bleak";
    tag = "v${version}";
    hash = "sha256-I+nN3/KKF0PC9TO8SULXX1oOGUokYa2tlPVfEJ/0mbY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build" \
      --replace-fail "ignore:Couldn't import C tracer:coverage.exceptions.CoverageWarning" ""
  ''
  # bleak checks BlueZ's version with a call to `bluetoothctl --version`
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace bleak/backends/bluezdbus/version.py \
      --replace-fail \
        '"bluetoothctl"' \
        '"${lib.getExe' bluez "bluetoothctl"}"'
  '';

  build-system = [ uv-build ];

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
  ];

  nativeCheckInputs = [
    bumble
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak" ];

  meta = {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    changelog = "https://github.com/hbldh/bleak/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ rhendric ];
  };
}
