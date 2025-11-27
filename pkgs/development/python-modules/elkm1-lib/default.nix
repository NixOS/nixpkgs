{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "elkm1-lib";
  version = "2.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    tag = version;
    hash = "sha256-Z8OfaRggVkGzX7d/O8a7L110ophj3sKD2x5JskusUe8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "elkm1_lib" ];

  meta = with lib; {
    description = "Python module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    changelog = "https://github.com/gwww/elkm1/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
