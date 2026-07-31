{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-iso639";
  version = "2026.7.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacksonllee";
    repo = "iso639";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6pJmSUbX1HTPYi7zww7gdXZAztRoWePNovvl3Se8SLI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "iso639" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jacksonllee/iso639/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "ISO 639 language codes, names, and other associated information";
    homepage = "https://github.com/jacksonllee/iso639";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
