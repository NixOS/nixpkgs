{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  djangorestframework-simplejwt,
  social-auth-app-django,
}:

buildPythonPackage rec {
  pname = "djoser";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunscrapers";
    repo = "djoser";
    tag = version;
    hash = "sha256-RFOKEjAh5k/Bx7cj6ty2vQsW61lsXfJIJDOZeqL6iCE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    djangorestframework-simplejwt
    social-auth-app-django
  ];

  # djet isn't packaged yet
  # nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "djoser" ];

  meta = {
    changelog = "https://github.com/sunscrapers/djoser/releases/tag/${src.tag}";
    description = "REST implementation of Django authentication system";
    homepage = "https://github.com/sunscrapers/djoser";
    maintainers = with lib.maintainers; [ MostafaKhaled ];
    license = lib.licenses.mit;
  };
}
