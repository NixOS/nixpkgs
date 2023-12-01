{ lib
, black
, buildPythonPackage
, cachecontrol
, fetchPypi
, importlib-resources
, lockfile
, mistune
, mypy
, pytestCheckHook
, pythonOlder
, rdflib
, ruamel-yaml
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.4.20230808163024";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ai4vv6EFX4yTR8sgRspiG+M8a8oa83LIlJPGX7q+Kd0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cachecontrol
    importlib-resources
    lockfile
    mistune
    mypy
    rdflib
    ruamel-yaml
    setuptools # needs pkg_resources at runtime
  ] ++ cachecontrol.optional-dependencies.filecache;

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
    # https://github.com/common-workflow-language/schema_salad/issues/721
    broken = versionAtLeast mistune.version "2.1";
  };
}
