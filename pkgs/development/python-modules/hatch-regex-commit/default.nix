{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "hatch-regex-commit";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "hatch-regex-commit";
    tag = "v${version}";
    hash = "sha256-xdt3qszigdCudt2+EpUZPkJzL+XQ6TnVEAMm0sV3zwY=";
  };

  build-system = [ hatchling ];

  dependencies = [ hatchling ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatch_regex_commit" ];

  meta = {
    description = "Hatch plugin to create a commit and tag when bumping version";
    homepage = "https://github.com/frankie567/hatch-regex-commit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
