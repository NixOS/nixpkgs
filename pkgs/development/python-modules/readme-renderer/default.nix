{ lib
, bleach
, buildPythonPackage
, cmarkgfm
, docutils
, fetchPypi
, nh3
, pygments
, pytestCheckHook
, pythonOlder
, setuptools
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

  build-system = [
    setuptools
  ];

  dependencies = [
    docutils
    nh3
    pygments
  ];

  optional-dependencies.md = [
    cmarkgfm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.md;

  disabledTests = [
    # https://github.com/pypa/readme_renderer/issues/221
    "test_GFM_"
    # https://github.com/pypa/readme_renderer/issues/274
    "test_CommonMark_008.md"
    "test_rst_008.rst"
    # Relies on old distutils behaviour removed by setuptools (TypeError: dist must be a Distribution instance)
    "test_valid_rst"
    "test_invalid_rst"
    "test_malicious_rst"
    "test_invalid_missing"
    "test_invalid_empty"
  ];

  pythonImportsCheck = [
    "readme_renderer"
  ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
