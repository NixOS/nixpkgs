{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bite-parser";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = "bite-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-C508csRbjCeLgkp66TwDuxUtMITTmub5/TFv8x80HLA=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bite" ];

  meta = {
    description = "Asynchronous parser taking incremental bites out of your byte input stream";
    homepage = "https://github.com/jgosmann/bite-parser";
    changelog = "https://github.com/jgosmann/bite-parser/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
