{ lib
, async-timeout
, bleak
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "1.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qRUS+JJWd2MPXa5Bs2WzZIHk6VcPe75yBoArFGk2yHQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bleak_retry_connector --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bleak_retry_connector"
  ];

  meta = with lib; {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
