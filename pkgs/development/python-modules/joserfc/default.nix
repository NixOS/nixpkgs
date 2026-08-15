{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  pycryptodome,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "joserfc";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authlib";
    repo = "joserfc";
    tag = finalAttrs.version;
    hash = "sha256-VE5WWkklZXMBPS+mXcJj+HLgyBYZkxu2AthLo5V78J8=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    drafts = [ pycryptodome ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # https://github.com/authlib/joserfc/issues/94
    "test_ECDH_ES_with_EC_key"
    "test_import_p512_key"
    "test_ec_incorrect_curve"
    "test_ES512"
  ];

  pythonImportsCheck = [ "joserfc" ];

  meta = {
    description = "Implementations of JOSE RFCs in Python";
    homepage = "https://github.com/authlib/joserfc";
    changelog = "https://github.com/authlib/joserfc/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
