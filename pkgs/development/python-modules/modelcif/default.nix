{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ihm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "modelcif";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihmwg";
    repo = "python-modelcif";
    tag = version;
    hash = "sha256-01tCE7uClUEpCFkdAvvjG18SwKypJ+oeQ9SbJZF3RVU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ ihm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # require network access
    "test_associated_example"
    "test_validate_mmcif_example"
    "test_validate_modbase_example"
  ];

  pythonImportsCheck = [ "modelcif" ];

  meta = {
    description = "Python package for handling ModelCIF mmCIF and BinaryCIF files";
    homepage = "https://github.com/ihmwg/python-modelcif";
    changelog = "https://github.com/ihmwg/python-modelcif/blob/${src.tag}/ChangeLog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
