{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # tests
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyfakefs";
  version = "5.8.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-flRX7jzGcGnTzvbieCJ+z8gL+2HpJbwKTTsK8y0cmc4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyfakefs" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  enabledTestPaths = [
    "pyfakefs/tests"
  ];

  disabledTests = [
    "test_expand_root"
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    # this test fails on darwin due to case-insensitive file system
    "test_rename_dir_to_existing_dir"
  ]);

  meta = with lib; {
    description = "Fake file system that mocks the Python file system modules";
    homepage = "https://pyfakefs.org/";
    changelog = "https://github.com/jmcgeheeiv/pyfakefs/blob/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
