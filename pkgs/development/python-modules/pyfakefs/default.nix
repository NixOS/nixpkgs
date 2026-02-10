{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyfakefs";
  version = "5.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZsXGzNQJe0hPh4L5pQeP7gUz1GXg2cr1lMkVfVQ4JVM=";
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

  meta = {
    description = "Fake file system that mocks the Python file system modules";
    homepage = "https://pyfakefs.org/";
    changelog = "https://github.com/jmcgeheeiv/pyfakefs/blob/v${version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
