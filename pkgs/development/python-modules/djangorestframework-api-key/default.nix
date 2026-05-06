{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  packaging,
}:

buildPythonPackage rec {
  pname = "djangorestframework-api-key";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "djangorestframework-api-key";
    tag = "v${version}";
    hash = "sha256-TyYSO3OQslipl2T5BtsTABaTJD4HMCX61TOZXNR+lXE=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    packaging
  ];

  pythonImportsCheck = [
    "rest_framework_api_key"
  ];

  meta = {
    description = "API key permissions for Django REST Framework";
    homepage = "https://github.com/florimondmanca/djangorestframework-api-key";
    changelog = "https://github.com/florimondmanca/djangorestframework-api-key/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
