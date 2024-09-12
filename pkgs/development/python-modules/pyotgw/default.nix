{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyotgw";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = "pyotgw";
    rev = "refs/tags/${version}";
    hash = "sha256-SowM+glni1PGkM87JT9+QWTD4Tu9XmsfXg99GZzSCJM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial-asyncio-fast ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyotgw" ];

  meta = with lib; {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    changelog = "https://github.com/mvn23/pyotgw/blob/${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
