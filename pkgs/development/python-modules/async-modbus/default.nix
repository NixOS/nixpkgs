{ lib
, buildPythonPackage
, connio
, fetchFromGitHub
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
