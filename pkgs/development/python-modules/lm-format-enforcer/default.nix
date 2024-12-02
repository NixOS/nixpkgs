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
  version = "0.10.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noamgat";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8+hve/6YezM07+4BmmBEAPZ0B2d8xDguXoHf7FuQWP8=";
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
