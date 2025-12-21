{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  swig,
  msgpack,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ihm";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-ihm";
    tag = version;
    hash = "sha256-sT2wZRKyW+N0gd6xwOAEXImMnWKWq8h9UX1b3qkDLGQ=";
  };

  nativeBuildInputs = [ swig ];

  build-system = [ setuptools ];

  dependencies = [ msgpack ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_validator_example"
  ];

  pythonImportsCheck = [ "ihm" ];

  meta = {
    description = "Python package for handling IHM mmCIF and BinaryCIF files";
    homepage = "https://github.com/ihmwg/python-ihm";
    changelog = "https://github.com/ihmwg/python-ihm/blob/${src.tag}/ChangeLog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
