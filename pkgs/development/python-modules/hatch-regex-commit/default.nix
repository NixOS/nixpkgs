{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hatch-regex-commit";
  version = "0.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "hatch-regex-commit";
    tag = "v${version}";
    hash = "sha256-E0DIBBaDmTCsZQ41NcjcbzgJ16BwhdexlrGWBdf77oA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
      --replace-fail ', "hatch-regex-commit"' "" \
      --replace-fail " --cov-report=term-missing --cov-config=pyproject.toml --cov=hatch_regex_commit --cov=tests" ""
  '';

  build-system = [ hatchling ];

  dependencies = [ hatchling ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatch_regex_commit" ];

  meta = with lib; {
    description = "Hatch plugin to create a commit and tag when bumping version";
    homepage = "https://github.com/frankie567/hatch-regex-commit";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
