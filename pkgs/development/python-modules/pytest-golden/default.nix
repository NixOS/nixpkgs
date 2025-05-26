{
  lib,
  atomicwrites,
  buildPythonPackage,
  fetchFromGitHub,
  ruamel-yaml,
  poetry-core,
  pytest,
  pytestCheckHook,
  pythonOlder,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "pytest-golden";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "pytest-golden";
    tag = "v${version}";
    hash = "sha256-l5fXWDK6gWJc3dkYFTokI9tWvawMRnF0td/lSwqkYXE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" poetry-core \
      --replace-fail poetry.masonry.api poetry.core.masonry.api
  '';

  pythonRelaxDeps = [ "testfixtures" ];

  build-system = [
    # hatchling used for > 0.2.2
    poetry-core
  ];

  buildInputs = [ pytest ];

  dependencies = [
    atomicwrites
    ruamel-yaml
    testfixtures
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_golden" ];

  meta = with lib; {
    description = "Plugin for pytest that offloads expected outputs to data files";
    homepage = "https://github.com/oprypin/pytest-golden";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
