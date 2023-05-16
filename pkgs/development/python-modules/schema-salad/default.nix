{ lib
, black
, buildPythonPackage
<<<<<<< HEAD
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
=======
, fetchPypi
, setuptools-scm
, cachecontrol
, lockfile
, mistune
, rdflib
, ruamel-yaml
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "schema-salad";
<<<<<<< HEAD
  version = "8.4.20230808163024";
=======
  version = "8.4.20230213094415";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ai4vv6EFX4yTR8sgRspiG+M8a8oa83LIlJPGX7q+Kd0=";
=======
    hash = "sha256-x2co8WjL+e4nBZd0pGUwv39nzNkO5G3dYrYJZeqP31o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cachecontrol
<<<<<<< HEAD
    importlib-resources
    lockfile
    mistune
    mypy
    rdflib
    ruamel-yaml
    setuptools # needs pkg_resources at runtime
  ] ++ cachecontrol.optional-dependencies.filecache;
=======
    lockfile
    mistune
    rdflib
    ruamel-yaml
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
