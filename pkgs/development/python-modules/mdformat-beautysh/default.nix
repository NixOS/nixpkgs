{
  lib,
  beautysh,
  buildPythonPackage,
  fetchFromGitHub,
  mdformat,
  mdformat-gfm,
  mdit-py-plugins,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-beautysh";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "mdformat-beautysh";
    tag = version;
    hash = "sha256-Wzwy2FSknohmgrZ/ACliBDD2lOaQKKHyacAL57Ci3SU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    beautysh
    mdformat
    mdformat-gfm
    mdit-py-plugins
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_beautysh" ];

  meta = with lib; {
    description = "Mdformat plugin to beautify Bash scripts";
    homepage = "https://github.com/hukkin/mdformat-beautysh";
    changelog = "https://github.com/hukkin/mdformat-beautysh/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
