{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  markdown-it-py,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "mdformat";
  version = "0.7.19";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat";
    rev = "refs/tags/${version}";
    hash = "sha256-t2yx8cIq8es3XOc2nbHPKjUUium5+RPZuD8oNWZxVV0=";
  };

  build-system = [ setuptools ];

  dependencies =
    [ markdown-it-py ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

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
