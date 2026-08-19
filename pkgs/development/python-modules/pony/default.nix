{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pony";
  version = "0.7.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ponyorm";
    repo = "pony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qSpgC3ka1dFxqh2ihVffEUTtAB9lxEvOcFDXLmBRf8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests are outdated
    "test_method"
    # https://github.com/ponyorm/pony/issues/704
    "test_composite_param"
    "test_equal_json"
    "test_equal_list"
    "test_len"
    "test_ne"
    "test_nonzero"
    "test_query"
  ];

  pythonImportsCheck = [ "pony" ];

  meta = {
    description = "Library for advanced object-relational mapping";
    homepage = "https://ponyorm.org/";
    changelog = "https://github.com/ponyorm/pony/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      d-goldin
      xvapx
    ];
  };
})
