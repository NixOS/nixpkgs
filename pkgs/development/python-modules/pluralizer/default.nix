{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pluralizer";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weixu365";
    repo = "pluralizer-py";
    tag = "v${version}";
    hash = "sha256-2m7E4cwAdmny/5R5FqaCzk8mu9so/ZCgNPBckTdIc/0=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pluralizer" ];

  meta = {
    description = "Singularize or pluralize a given word using a pre-defined list of rules";
    homepage = "https://github.com/weixu365/pluralizer-py";
    changelog = "https://github.com/weixu365/pluralizer-py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.ngi ];
  };
}
