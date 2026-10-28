{
  lib,
  buildPythonPackage,
  cmarkgfm,
  docutils,
  fetchPypi,
  nh3,
  pygments,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "readme-renderer";
  version = "45.0";
  pyproject = true;

  src = fetchPypi {
    pname = "readme_renderer";
    inherit (finalAttrs) version;
    hash = "sha256-AwqPrHSQT4+6Ea0btpZOP3boltx+XnHxavGQyQVmltE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    nh3
    pygments
  ];

  optional-dependencies = {
    md = [ cmarkgfm ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    "test_rst_fixtures"
    "test_rst_008.rst"
  ];

  pythonImportsCheck = [ "readme_renderer" ];

  meta = {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    changelog = "https://github.com/pypa/readme_renderer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
