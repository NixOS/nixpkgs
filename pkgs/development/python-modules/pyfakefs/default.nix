{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,

  # extra tests
  openpyxl,
  pandas,
  xlrd,
}:
let
  self = buildPythonPackage (finalAttrs: {
    pname = "pyfakefs";
    version = "6.2.0";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-5Zo220R79QnOnJerPRUQwIzFGJXFMRMlpWCl5bXcGUA=";
    };

    build-system = [ setuptools ];

    pythonImportsCheck = [ "pyfakefs" ];

    nativeCheckInputs = [
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

    # Keep the big pandas 'extra' dependency outside the standard build: providing it enables only two additional tests
    # The other two members of the 'extra' group (xlrd and openpyxl) enable two more tests
    passthru.tests.extra = self.overridePythonAttrs (prevPythonAttrs: {
      nativeCheckInputs = prevPythonAttrs.nativeCheckInputs ++ [
        pandas
        xlrd
        openpyxl
      ];
    });

    __structuredAttrs = true;

    meta = {
      description = "Fake file system that mocks the Python file system modules";
      homepage = "https://pyfakefs.org/";
      changelog = "https://github.com/jmcgeheeiv/pyfakefs/blob/v${finalAttrs.version}/CHANGES.md";
      license = lib.licenses.asl20;
      maintainers = [ ];
    };
  });
in
self
