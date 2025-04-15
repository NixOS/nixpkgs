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
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-ihm";
    tag = version;
    hash = "sha256-vlt1YDF8TiWOfql/pasHU1Q7N0EU1wz60yh3+KAVnvM=";
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

  meta = with lib; {
    description = "Python package for handling IHM mmCIF and BinaryCIF files";
    homepage = "https://github.com/ihmwg/python-ihm";
    changelog = "https://github.com/ihmwg/python-ihm/blob/${src.tag}/ChangeLog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
