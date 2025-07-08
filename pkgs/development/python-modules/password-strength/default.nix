{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "password-strength";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kolypto";
    repo = "py-password-strength";
    tag = "v${version}";
    hash = "sha256-8zjyo0jC4PxFJxM0VZ/u29heqqO5UbkOKAVxtNkcb7U=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # tests use nose
  doCheck = false;

  pythonImportsCheck = [ "password_strength" ];

  meta = {
    description = "Password strength and validation checker";
    homepage = "https://github.com/kolypto/py-password-strength";
    changelog = "https://github.com/kolypto/py-password-strength/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
