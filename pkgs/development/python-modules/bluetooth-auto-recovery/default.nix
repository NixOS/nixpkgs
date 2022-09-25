{ lib
, async-timeout
, btsocket
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyric
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bluetooth-auto-recovery";
  version = "0.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vzSpQ43vy0a+8PWdTz/RjdXGxwmebdBX/qXhF6Mnw4Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    btsocket
    pyric
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluetooth_auto_recovery --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluetooth_auto_recovery"
  ];

  meta = with lib; {
    description = "Library for recovering Bluetooth adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
