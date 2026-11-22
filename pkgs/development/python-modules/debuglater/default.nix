{
  lib,
  buildPythonPackage,
  colorama,
  dill,
  fetchFromGitHub,
  numpy,
  pandas,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "debuglater";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "debuglater";
    tag = finalAttrs.version;
    hash = "sha256-o9IAk3EN8ghEft7Y7Xx+sEjWMNgoyiZ0eiBqnCyXkm8=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorama ];

  optional-dependencies = {
    all = [ dill ];
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "debuglater" ];

  disabledTests = [
    # Assertion error
    "test_data_structures"
  ];

  meta = {
    description = "Module for post-mortem debugging of Python programs";
    homepage = "https://github.com/ploomber/debuglater";
    changelog = "https://github.com/ploomber/debuglater/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
