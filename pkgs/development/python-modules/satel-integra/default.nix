{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cryptography,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "satel-integra";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "c-soft";
    repo = "satel_integra";
    tag = version;
    hash = "sha256-fuSkLJDxrTgOWYwde1mAwFebYuTA3gsZmxONxgd4bhc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "satel_integra" ];

  meta = {
    description = "Communication library and basic testing tool for Satel Integra alarm system";
    homepage = "https://github.com/c-soft/satel_integra";
    changelog = "https://github.com/c-soft/satel_integra/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
