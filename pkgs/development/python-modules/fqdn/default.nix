{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "fqdn";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ypcrts";
    repo = "fqdn";
    tag = "v${version}";
    hash = "sha256-NwWX4qJWBQuP4gdPOuGVnx56IH2b6cfaBXIIK9uvi98=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fqdn" ];

  meta = {
    description = "RFC-compliant FQDN validation and manipulation";
    homepage = "https://github.com/ypcrts/fqdn";
    changelog = "https://github.com/ypcrts/fqdn/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
