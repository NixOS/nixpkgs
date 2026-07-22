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

buildPythonPackage rec {
  pname = "joserfc";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authlib";
    repo = "joserfc";
    tag = version;
    hash = "sha256-druh7ybcQBjTxUFMVLUwknw/aa/fyrUdS4ftS/ftYeA=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    drafts = [ pycryptodome ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # https://github.com/authlib/joserfc/issues/94
    "test_ECDH_ES_with_EC_key"
    "test_import_p512_key"
    "test_ec_incorrect_curve"
    "test_ES512"
  ];

  pythonImportsCheck = [ "joserfc" ];

  meta = {
    changelog = "https://github.com/authlib/joserfc/blob/${src.tag}/docs/changelog.rst";
    description = "Implementations of JOSE RFCs in Python";
    homepage = "https://github.com/authlib/joserfc";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
