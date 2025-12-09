{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-cov-stub,
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [ hatchling ];

  nativeCheckInputs = [ pytest-cov-stub ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatch_regex_commit" ];

  meta = with lib; {
    description = "Hatch plugin to create a commit and tag when bumping version";
    homepage = "https://github.com/frankie567/hatch-regex-commit";
    changelog = "https://github.com/frankie567/hatch-regex-commit/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
