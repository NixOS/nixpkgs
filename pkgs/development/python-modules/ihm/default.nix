{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  swig,
  msgpack,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ihm";
  version = "2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-ihm";
    tag = finalAttrs.version;
    hash = "sha256-fB47GL4dtWlnSYQRUE2tu82XIzY/s7UVP8jUgtyuXb0=";
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
    changelog = "https://github.com/ihmwg/python-ihm/blob/${finalAttrs.src.tag}/ChangeLog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
