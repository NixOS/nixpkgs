{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-madvr2";
  version = "1.6.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iloveicedgreentea";
    repo = "py-madvr";
    rev = "refs/tags/${version}";
    hash = "sha256-ibgmUpHSmOr5glSZPIJXTBDlEnQoWtmJzmEGsggQxnk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "madvr" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # https://github.com/iloveicedgreentea/py-madvr/issues/12
  doCheck = false;

  meta = {
    changelog = "https://github.com/iloveicedgreentea/py-madvr/releases/tag/${version}";
    description = "Control MadVR Envy over IP";
    homepage = "https://github.com/iloveicedgreentea/py-madvr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
