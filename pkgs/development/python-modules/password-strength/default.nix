{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  unittestCheckHook,
}:
let
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "kolypto";
    repo = "py-password-strength";
    rev = "refs/tags/v${version}";
    hash = "sha256-8zjyo0jC4PxFJxM0VZ/u29heqqO5UbkOKAVxtNkcb7U=";
  };
in
buildPythonPackage {
  pname = "password-strength";
  inherit version src;
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "password_strength" ];

  # nativeCheckInputs = [ unittestCheckHook ];
  #
  # unittestFlagsArray = [
  #   "-s"
  #   "tests"
  # ];

  meta = {
    description = "Password strength and validation.";
    homepage = "https://github.com/kolypto/py-password-strength";
    changelog = "https://github.com/kolypto/py-password-strength/blob/${src.rev}/CHANGES.txt";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
