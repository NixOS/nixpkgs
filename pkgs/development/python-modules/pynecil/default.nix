{
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynecil";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pynecil";
    rev = "refs/tags/v${version}";
    hash = "sha256-57TPgEC7NY75iVj31tdpCOrXUOcsFBy/4XltEHxlNFk=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [ bleak ];

  pythonImportsCheck = [ "pynecil" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/pynecil/releases/tag/v${version}";
    description = "Python library to communicate with Pinecil V2 soldering irons via Bluetooth";
    homepage = "https://github.com/tr4nt0r/pynecil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
