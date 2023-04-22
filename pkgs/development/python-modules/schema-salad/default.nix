{ lib
, black
, buildPythonPackage
, fetchPypi
, setuptools-scm
, cachecontrol
, lockfile
, mistune
, rdflib
, ruamel-yaml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.4.20230213094415";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x2co8WjL+e4nBZd0pGUwv39nzNkO5G3dYrYJZeqP31o=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cachecontrol
    lockfile
    mistune
    rdflib
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pycodegen;

  preCheck = ''
    rm tox.ini
  '';

  disabledTests = [
    # Setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
    # Test requires network
    "test_yaml_tab_error"
    "test_bad_schemas"
  ];

  pythonImportsCheck = [
    "schema_salad"
  ];

  passthru.optional-dependencies = {
    pycodegen = [
      black
    ];
  };

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    changelog = "https://github.com/common-workflow-language/schema_salad/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
