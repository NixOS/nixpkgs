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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koaning";
    repo = "mktestdocs";
    rev = "refs/tags/${version}";
    hash = "sha256-snlt6SDiDYr04b2b2NgBC/1IBffpei034vFx3fnYUOc=";
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
