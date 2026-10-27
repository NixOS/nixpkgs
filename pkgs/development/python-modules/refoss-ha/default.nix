{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "refoss-ha";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashionky";
    repo = "refoss_ha";
    tag = "v${version}";
    hash = "sha256-hU4PzkJNacCLRkMr9mRqORNhEkqiztkprYssyVTpoOQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "refoss_ha" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/ashionky/refoss_ha/releases/tag/v${version}";
    description = "Refoss support for Home Assistant";
    homepage = "https://github.com/ashionky/refoss_ha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
