{
  lib,
  aioconsole,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  poetry-dynamic-versioning,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  tzdata,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "melnor-bluetooth";
  version = "0.0.25";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vanstinator";
    repo = "melnor-bluetooth";
    rev = "refs/tags/v${version}";
    hash = "sha256-BQKXQrPT/+qm9cRO7pfScPwW0iwdhliTfX4XJ/kRQG0=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aioconsole
    bleak
    bleak-retry-connector
    deprecated
    tzdata
    tzlocal
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "melnor_bluetooth" ];

  meta = {
    description = "Module to interact with Melnor and Eden bluetooth watering timers";
    homepage = "https://github.com/vanstinator/melnor-bluetooth";
    changelog = "https://github.com/vanstinator/melnor-bluetooth/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
