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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "sunscrapers";
    repo = "djoser";
    tag = version;
    hash = "sha256-xPhf7FiJSq5bHfAU5RKbobgnsRh/6cLcXP6vfrLdzJA=";
  };

  buildInputs = [
    django
    djangorestframework-simplejwt
    social-auth-app-django
  ];

  pyproject = true;

  build-system = [
    poetry-core
  ];

  # djet isn't packaged yet
  # nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "djoser" ];

  meta = {
    changelog = "https://github.com/sunscrapers/djoser/releases/tag/${version}";
    description = "REST implementation of Django authentication system";
    homepage = "https://github.com/sunscrapers/djoser";
    maintainers = with lib.maintainers; [ MostafaKhaled ];
    license = lib.licenses.mit;
  };
}
