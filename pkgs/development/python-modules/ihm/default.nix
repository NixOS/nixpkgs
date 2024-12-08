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
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-ihm";
    rev = "refs/tags/${version}";
    hash = "sha256-Uz/4Egd7swY4kDl6FR564eiaYEdY9IUoz2Lv5pJ1C30=";
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
    changelog = "https://github.com/ihmwg/python-ihm/blob/${src.rev}/ChangeLog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
