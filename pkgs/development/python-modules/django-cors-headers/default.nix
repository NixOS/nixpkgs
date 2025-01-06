{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  django,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    hash = "sha256-/uTQ09zIjRV1Ilb/mXyr4zn5tJI/mNFHpfql2ptuER4=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "corsheaders" ];

  meta = {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
