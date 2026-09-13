{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  setuptools,
  fetchFromGitHub,
  lxml,
}:

buildPythonPackage rec {
  pname = "django-amenities";
  version = "0-unstable-2025-09-17";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "django-amenities";
    # No tagged release yet
    rev = "0b2a1298f3f6d121d2c9d628587a74d9d9f9d57f";
    hash = "sha256-GsHfFAbfJ84JG6ROGx9QOccAjBrEFpebPKFNcfR4D9w=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ django ];

  pythonImportsCheck = [ "django_amenities" ];

  meta = {
    description = "Django App to import and store OpenStreetMap nodes";
    homepage = "https://github.com/okfde/django-amenities";
    changelog = "https://github.com/okfde/django-amenities/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
