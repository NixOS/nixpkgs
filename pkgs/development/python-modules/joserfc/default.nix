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
  version = "1.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authlib";
    repo = "joserfc";
    tag = version;
    hash = "sha256-Ge1r34GVmpJ9h5GtRkPd0mkV7HuLf7D31ikuPAnpkuY=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    drafts = [ pycryptodome ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "joserfc" ];

  meta = {
    changelog = "https://github.com/authlib/joserfc/blob/${src.tag}/docs/changelog.rst";
    description = "Implementations of JOSE RFCs in Python";
    homepage = "https://github.com/authlib/joserfc";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
