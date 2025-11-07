{
  lib,
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

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/version.py \
      --replace-fail \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    dbus-fast
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

  meta = with lib; {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    changelog = "https://github.com/hbldh/bleak/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
