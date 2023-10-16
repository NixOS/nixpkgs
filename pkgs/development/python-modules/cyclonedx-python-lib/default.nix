{ lib
, buildPythonPackage
, ddt
, fetchFromGitHub
, importlib-metadata
, jsonschema
, license-expression
, lxml
, packageurl-python
, py-serializable
, pythonRelaxDepsHook
, poetry-core
, pytestCheckHook
, pythonOlder
, requirements-parser
, sortedcontainers
, setuptools
, toml
, types-setuptools
, types-toml
, xmldiff
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "4.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python-lib";
    rev = "refs/tags/v${version}";
    hash = "sha256-7bqIKwKGfMj5YPqZpvWtP881LNOgvJ+DMHs1U63gCN0=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    importlib-metadata
    license-expression
    packageurl-python
    requirements-parser
    setuptools
    sortedcontainers
    toml
    py-serializable
    types-setuptools
    types-toml
  ];

  nativeCheckInputs = [
    ddt
    jsonschema
    lxml
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [
    "cyclonedx"
  ];

  pythonRelaxDeps = [
    "py-serializable"
  ];

  preCheck = ''
    export PYTHONPATH=tests''${PYTHONPATH+:$PYTHONPATH}
  '';

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    # These tests require network access.
    "test_bom_v1_3_with_metadata_component"
    "test_bom_v1_4_with_metadata_component"
  ];

  disabledTestPaths = [
    # Test failures seem py-serializable related
    "tests/test_output_xml.py"
  ];

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    changelog = "https://github.com/CycloneDX/cyclonedx-python-lib/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
