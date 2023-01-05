{ lib
, buildPythonPackage
, connio
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, umodbus
}:

buildPythonPackage rec {
  pname = "async-modbus";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = "async_modbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-OTt/rUa3KLVSFOIUyMNHnqHvPtISxTposNFAgoixRfk=";
  };

  patches = [
    (fetchpatch {
      # Fix tests; https://github.com/tiagocoutinho/async_modbus/pull/13
      url = "https://github.com/tiagocoutinho/async_modbus/commit/d81d8ffe94870f0f505e0c8a0694768c98053ecc.patch";
      hash = "sha256-mG3XO2nAFYitatkswU7er29BJc/A0IL1rL2Zu4daZ7k=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"--cov=async_modbus",' "" \
      --replace '"--cov-report=html", "--cov-report=term",' "" \
      --replace '"--durations=2", "--verbose"' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    connio
    umodbus
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "async_modbus"
  ];

  meta = with lib; {
    description = "Library for Modbus communication";
    homepage = "https://github.com/tiagocoutinho/async_modbus";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
