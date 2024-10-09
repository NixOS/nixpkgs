{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiooui";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "aiooui";
    rev = "refs/tags/v${version}";
    hash = "sha256-dsMVKfY9o1krzp100/7JtClgPrpsFTVNwMnYMqOVFIU=";
  };

  postPatch = ''
    # Remove requirements and build part for the OUI data
    substituteInPlace pyproject.toml \
      --replace-fail "-v -Wdefault --cov=aiooui --cov-report=term-missing:skip-covered" "" \
      --replace-fail 'script = "build_oui.py"' "" \
      --replace-fail ", 'requests'" "" \
      --replace-fail '"setuptools>=65.4.1", ' ""
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiooui" ];

  meta = with lib; {
    description = "Async OUI lookups";
    homepage = "https://github.com/Bluetooth-Devices/aiooui";
    changelog = "https://github.com/Bluetooth-Devices/aiooui/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
