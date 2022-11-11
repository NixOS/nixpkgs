{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bluetooth-data-tools";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5FOFN2B35dTYuZhO09HZ/sNkY5X16bICP+qWzmrua5o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluetooth_data_tools --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluetooth_data_tools"
  ];

  meta = with lib; {
    description = "Library for converting bluetooth data and packets";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-data-tools";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
