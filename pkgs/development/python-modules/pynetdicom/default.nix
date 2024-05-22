{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pydicom,
  pyfakefs,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pynetdicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-/JWQUtFBW4uqCbs/nUxj1pRBfTCXV4wcqTkqvzpdFrM=";
  };

  patches = [
    (fetchpatch {
      name = "fix-python-3.11-test-attribute-errors.patch";
      url = "https://github.com/pydicom/pynetdicom/pull/754/commits/2126bd932d6dfb3f07045eb9400acb7eaa1b3069.patch";
      hash = "sha256-t6Lg0sTZSWIE5q5pkBvEoHDQ+cklDn8SgNBcFk1myp4=";
    })
    (fetchpatch {
      # https://github.com/pydicom/pynetdicom/pull/848
      name = "replace-setup-with-setup_method1.patch";
      url = "https://github.com/pydicom/pynetdicom/commit/09b4e0901445d46868668bc69a7b4f7f00cf6cbb.patch";
      hash = "sha256-1ea1A/LU6qY+hd23b6H4OkKHQ0hI2/MYgBgZUZE0kRU=";
    })
    (fetchpatch {
      # https://github.com/pydicom/pynetdicom/pull/848
      name = "replace-setup-with-setup_method2.patch";
      url = "https://github.com/pydicom/pynetdicom/commit/3966c2d749eeda718caccf9a88a0495d1823825d.patch";
      hash = "sha256-C4MSfwwxDgr5T0XQMlR5j2wElPu83TqPhjyNDvfBjJs=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ pydicom ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
    sqlalchemy
  ];

  disabledTests = [
    # Some tests needs network capabilities
    "test_str_types_empty"
    "test_associate_reject"
    "TestAEGoodAssociation"
    "TestEchoSCP"
    "TestEchoSCPCLI"
    "TestEventHandlingAcceptor"
    "TestEventHandlingRequestor"
    "TestFindSCP"
    "TestFindSCPCLI"
    "TestGetSCP"
    "TestGetSCPCLI"
    "TestMoveSCP"
    "TestMoveSCPCLI"
    "TestPrimitive_N_GET"
    "TestQRGetServiceClass"
    "TestQRMoveServiceClass"
    "TestSearch"
    "TestState"
    "TestStorageServiceClass"
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
  ];

  disabledTestPaths =
    [
      # Ignore apps tests
      "pynetdicom/apps/tests/"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/pydicom/pynetdicom/issues/924
      "pynetdicom/tests/test_assoc.py"
      "pynetdicom/tests/test_transport.py"
    ];

  pythonImportsCheck = [ "pynetdicom" ];

  pytestFlagsArray = [
    # https://github.com/pydicom/pynetdicom/issues/923
    "-W"
    "ignore::pytest.PytestRemovedIn9Warning"
  ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    changelog = "https://github.com/pydicom/pynetdicom/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Tests are not passing on Darwin/Aarch64, thus it's assumed that it doesn't work
    broken = stdenv.isDarwin || stdenv.isAarch64;
  };
}
