{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  ihm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "modelcif";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-modelcif";
    rev = "refs/tags/${version}";
    hash = "sha256-u+e2QtG6gO1e31OzPfAuzfCkwZymEZMxa2p0haYplAk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ ihm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # require network access
    "test_validate_mmcif_example"
    "test_validate_modbase_example"
  ];

  pythonImportsCheck = [ "modelcif" ];

  meta = with lib; {
    description = "Python package for handling ModelCIF mmCIF and BinaryCIF files";
    homepage = "https://github.com/ihmwg/python-modelcif";
    changelog = "https://github.com/ihmwg/python-modelcif/blob/${src.rev}/ChangeLog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
