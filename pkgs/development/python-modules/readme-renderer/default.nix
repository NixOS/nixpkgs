{
  lib,
  buildPythonPackage,
  cmarkgfm,
  docutils,
  fetchPypi,
  nh3,
  pygments,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "43.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    hash = "sha256-GBjdKBQIE1Ce7tjWJof3zU97rZDU21hgAcXcCdT94xE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    nh3
    pygments
  ];

  optional-dependencies.md = [ cmarkgfm ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.md;

  disabledTests = [
    "test_rst_fixtures"
    "test_rst_008.rst"
  ];

  pythonImportsCheck = [ "readme_renderer" ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    changelog = "https://github.com/pypa/readme_renderer/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
