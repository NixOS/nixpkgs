{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown-it-py,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mdformat";
  version = "0.7.21";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat";
    tag = version;
    hash = "sha256-lsjALgLuk1wpltSW58N7pMNXwIxXBLdlHinMuBo+juk=";
  };

  build-system = [ setuptools ];

  dependencies = [ markdown-it-py ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat" ];

  passthru = {
    withPlugins = throw "Use pkgs.mdformat.withPlugins, i.e. the top-level attribute.";
  };

  meta = with lib; {
    description = "CommonMark compliant Markdown formatter";
    homepage = "https://mdformat.rtfd.io/";
    changelog = "https://github.com/executablebooks/mdformat/blob/${version}/docs/users/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      aldoborrero
    ];
    mainProgram = "mdformat";
  };
}
