{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pydantic,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "doubleratchet";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-doubleratchet";
    tag = "v${version}";
    hash = "sha256-yoph3u7LjGjSPi1hFlXzWmSNkCXvY/ocTt2MKa+F1fs=";
  };

  strictDeps = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "doubleratchet" ];

  meta = {
    description = "Python implementation of the Double Ratchet algorithm";
    homepage = "https://github.com/Syndace/python-doubleratchet";
    changelog = "https://github.com/Syndace/python-doubleratchet/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ axler1 ];
  };
}
