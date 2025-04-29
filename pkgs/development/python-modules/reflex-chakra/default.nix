{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  reflex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reflex-chakra";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex-chakra";
    tag = "v${version}";
    hash = "sha256-foIXPLWcxNf33y39BgiRpvwRnZOTcfAjhCvC4TD8ZMs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    reflex
  ];

  pythonImportsCheck = [ "reflex_chakra" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # there are no "test_*.py" files, and the
  # other files with `test_*` functions are not maintained it seems
  doCheck = false;

  meta = {
    description = "Chakra Implementation in Reflex";
    homepage = "https://github.com/reflex-dev/reflex-chakra";
    changelog = "https://github.com/reflex-dev/reflex-chakra/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
