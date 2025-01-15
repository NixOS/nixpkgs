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
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    hash = "sha256-Dvsuj+U1YFC9jT5qkh2h1aL71JkRsAyXW4rxhLzEbOw=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "corsheaders" ];

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    license = licenses.mit;
    maintainers = [ ];
  };
}
