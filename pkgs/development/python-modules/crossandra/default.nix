{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-mypyc,
  pytestCheckHook,
  result,
}:

buildPythonPackage (finalAttrs: {
  pname = "crossandra";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "crossandra";
    tag = finalAttrs.version;
    hash = "sha256-xKMySbt+Bf+6BGyIKsmYHTZTl25HxlG8hY/HuUtDjSM=";
  };

  build-system = [
    hatchling
    hatch-mypyc
  ];

  dependencies = [ result ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crossandra" ];

  meta = {
    changelog = "https://github.com/trag1c/crossandra/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast and simple enum/regex-based tokenizer with decent configurability";
    license = lib.licenses.mit;
    homepage = "https://trag1c.github.io/crossandra";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
