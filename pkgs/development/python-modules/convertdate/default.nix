{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymeeus,
  pytz,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "convertdate";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fitnr";
    repo = "convertdate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YgLKUSg95j9rRejkmep+Levy5Rvnl/kXEiXuS7hazbY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pymeeus
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "convertdate" ];

  meta = {
    description = "Utils for converting between date formats and calculating holidays";
    homepage = "https://github.com/fitnr/convertdate";
    changelog = "https://github.com/fitnr/convertdate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "censusgeocode";
  };
})
