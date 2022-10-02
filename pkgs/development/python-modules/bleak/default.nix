{ lib
, async-timeout
, bluez
, buildPythonPackage
, dbus-fast
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.18.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2/jJ2C2TudwCAshDBLUQjNMbYa2j4XfW8bXmeWrAyrA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    dbus-fast
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/__init__.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  pythonImportsCheck = [
    "bleak"
  ];

  meta = with lib; {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
