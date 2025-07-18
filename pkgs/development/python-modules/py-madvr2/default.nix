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
  version = "1.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iloveicedgreentea";
    repo = "py-madvr";
    tag = "v${version}";
    hash = "sha256-LVu2FYUQjnFE+dsAF1dvi9cXqb+hsWQ4wqxPcZBCZrs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "madvr" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/iloveicedgreentea/py-madvr/releases/tag/${src.tag}";
    description = "Control MadVR Envy over IP";
    homepage = "https://github.com/iloveicedgreentea/py-madvr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
