{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  pytestCheckHook,
  pyyaml,
  requests,
  requests-mock,
  sqlite-utils,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "github-to-sqlite";
  version = "2.9";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "dogsheep";
    repo = "github-to-sqlite";
    tag = finalAttrs.version;
    hash = "sha256-KwLaaZxBBzRhiBv4p8Imb5XI1hyka9rmr/rxA6wDc7Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlite-utils
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [ "test_scrape_dependents" ];

  meta = {
    description = "Save data from GitHub to a SQLite database";
    mainProgram = "github-to-sqlite";
    homepage = "https://github.com/dogsheep/github-to-sqlite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
  };
})
