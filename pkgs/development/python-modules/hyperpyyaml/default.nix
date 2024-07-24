{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  ruamel-yaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyperpyyaml";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "hyperpyyaml";
    rev = "refs/tags/v${version}";
    hash = "sha256-eA4/wXmqlqomfRbJNi7dkBRoxneCbCbURSPvASF2sgA=";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyperpyyaml" ];

  meta = with lib; {
    description = "Extensions to YAML syntax for better python interaction";
    homepage = "https://github.com/speechbrain/HyperPyYAML";
    changelog = "https://github.com/speechbrain/HyperPyYAML/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
