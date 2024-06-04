{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  bleak,
  pyyaml,
  voluptuous,
  pytestCheckHook,
  pytest-asyncio,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "idasen";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "idasen";
    rev = "refs/tags/v${version}";
    hash = "sha256-TQ+DBFpG+IeZ4/dN+YKMw3AM4Dl1rpqA1kRcb3Tb3jA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    bleak
    pyyaml
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "idasen" ];

  meta = with lib; {
    description = "Python API and CLI for the ikea IDÅSEN desk";
    mainProgram = "idasen";
    homepage = "https://github.com/newAM/idasen";
    changelog = "https://github.com/newAM/idasen/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
