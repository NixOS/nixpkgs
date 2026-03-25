{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pwkit";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pkgw";
    repo = "pwkit";
    tag = "pwkit@${version}";
    hash = "sha256-FEMPHdXj2XCV5fCcdJsVpDMsJntP6zp1yFkjv1ov478=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pwkit" ];

  meta = {
    description = "Miscellaneous science/astronomy tools";
    homepage = "https://github.com/pkgw/pwkit/";
    changelog = "https://github.com/pkgw/pwkit/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
