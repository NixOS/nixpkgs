{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mktestdocs";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koaning";
    repo = "mktestdocs";
    tag = version;
    hash = "sha256-OiOkU/qfxeLbCT1QywA1rGSwe9Ja8tENTmBo93vo0vc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mktestdocs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Run pytest against markdown files/docstrings";
    homepage = "https://github.com/koaning/mktestdocs";
    changelog = "https://github.com/koaning/mktestdocs/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
