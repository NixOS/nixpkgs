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
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noamgat";
    repo = "lm-format-enforcer";
    tag = "v${version}";
    hash = "sha256-aUZo7Nlk5A9SRyQFFGhy3LAJO29ygRFwNC4WbRuXvYE=";
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
  };
}
