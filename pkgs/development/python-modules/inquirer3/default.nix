{
  blessed,
  buildPythonPackage,
  editor,
  fetchFromGitHub,
  lib,
  pexpect,
  poetry-core,
  pytestCheckHook,
  readchar,
}:

buildPythonPackage (finalAttrs: {
  pname = "inquirer3";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guysalt";
    repo = "python-inquirer3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IReJlwVgjTlTlD0xTVWrzQ0ITvCQvPJ86zCmffaoPk4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    blessed
    editor
    readchar
  ];

  pythonImportsCheck = [ "inquirer3" ];

  nativeCheckInputs = [
    pexpect
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/guysalt/python-inquirer3/releases/tag/${finalAttrs.src.tag}";
    description = "Collection of common interactive command line user interfaces, based on Inquirer.js";
    homepage = "https://github.com/guysalt/python-inquirer3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
