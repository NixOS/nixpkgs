{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  interegular,
  pyyaml,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "lm-format-enforcer";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noamgat";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DlHZ1gF+SJlAFZD5G1ATx5alutT2dctZa5gBNYmFh9E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    interegular
    pydantic
    pyyaml
  ];

  doCheck = false; # most tests require internet access

  pythonImportsCheck = [ "lmformatenforcer" ];

  meta = with lib; {
    description = "Enforce the output format (JSON Schema, Regex etc) of a language model";
    changelog = "https://github.com/noamgat/lm-format-enforcer/releases/tag/v${version}";
    homepage = "https://github.com/noamgat/lm-format-enforcer";
    license = licenses.mit;
    maintainers = with maintainers; [ cfhammill ];
  };
}
