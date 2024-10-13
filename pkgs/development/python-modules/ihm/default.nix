{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  swig,
  wheel,
  msgpack,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ihm";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-ihm";
    rev = "refs/tags/${version}";
    hash = "sha256-G6u1z0bPC6EDVMLL9oCWi2B7AEj4UikGnSDQ8AOpuMA=";
  };

  nativeBuildInputs = [
    setuptools
    swig
    wheel
  ];

  propagatedBuildInputs = [ msgpack ];

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
