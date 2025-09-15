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
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = "bleak";
    tag = "v${version}";
    hash = "sha256-JHTyTHMMZDD75baQK3nf4R+8eW0Tt62CMTXb8eRKp94=";
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
