{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
  zhon,
}:

buildPythonPackage rec {
  pname = "hanzidentifier";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsroten";
    repo = "hanzidentifier";
    tag = "v${version}";
    hash = "sha256-SXIMk5Pr2jqoWOjKfVVhe6fHdbh3j+5Lnlru7St8bgA=";
  };

  build-system = [ hatchling ];

  dependencies = [ zhon ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "hanzidentifier" ];

  meta = {
    description = "Python module that identifies Chinese text as being Simplified or Traditional";
    homepage = "https://github.com/tsroten/hanzidentifier";
    changelog = "https://github.com/tsroten/hanzidentifier/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
