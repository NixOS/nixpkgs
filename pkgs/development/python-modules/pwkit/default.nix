{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pwkit";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pkgw";
    repo = "pwkit";
    rev = "refs/tags/pwkit@${version}";
    hash = "sha256-FEMPHdXj2XCV5fCcdJsVpDMsJntP6zp1yFkjv1ov478=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pwkit" ];

  meta = with lib; {
    description = "Miscellaneous science/astronomy tools";
    homepage = "https://github.com/pkgw/pwkit/";
    changelog = "https://github.com/pkgw/pwkit/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
