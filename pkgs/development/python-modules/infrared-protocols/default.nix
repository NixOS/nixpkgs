{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "infrared-protocols";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "infrared-protocols";
    tag = finalAttrs.version;
    hash = "sha256-Sw9N8vdmdR13itUtx3Vcmc0DJN8IcIub+mzEWms/fpE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "infrared_protocols" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/infrared-protocols/releases/tag/${finalAttrs.src.tag}";
    description = "Library to decode and encode infrared signals";
    homepage = "https://github.com/home-assistant-libs/infrared-protocols";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
