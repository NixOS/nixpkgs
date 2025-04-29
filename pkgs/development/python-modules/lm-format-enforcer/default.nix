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
  version = "0.10.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noamgat";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-8BsfA1R/X+wA0H0MqQKn+CljUIT8VdoInoczSGvu74o=";
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
    changelog = "https://github.com/noamgat/lm-format-enforcer/releases/tag/${src.tag}";
    homepage = "https://github.com/noamgat/lm-format-enforcer";
    license = licenses.mit;
    maintainers = with maintainers; [ cfhammill ];
  };
}
