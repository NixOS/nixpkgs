{
  buildPythonPackage,
  cached-property,
  click,
  coloredlogs,
  fetchFromGitLab,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "la-panic";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "yanivhasbanidev";
    repo = "la_panic";
    tag = version;
    hash = "sha256-V9VUSp5uvj4jR3oVHdRjvnNDGB1a5bi8elu/ry4jq00=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cached-property
    click
    coloredlogs
  ];

  pythonImportsCheck = [ "la_panic" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://gitlab.com/yanivhasbanidev/la_panic/-/tags/${src.tag}";
    description = "AppleOS Kernel Panic Parser";
    homepage = "https://gitlab.com/yanivhasbanidev/la_panic";
    license = lib.licenses.gpl3Plus;
    mainProgram = "la_panic";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
