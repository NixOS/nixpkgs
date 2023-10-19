{ lib
, buildPythonPackage
, dunamai
, fetchFromGitHub
, jinja2
, poetry-core
, poetry
, pytestCheckHook
, pythonOlder
, tomlkit
}:

buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BGAo3c0TzyhIiDtZjoEP+Eeu51WJB3Wg71poFMWJ+VM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dunamai
    jinja2
    tomlkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    poetry
  ];

  # virtualenv: error: argument dest: the destination . is not write-able at /
  doCheck = false;

  disabledTests = [
    # these require .git, but leaveDotGit = true doesn't help
    "test__get_version__defaults"
    "test__get_version__format_jinja"
    # these expect to be able to run the poetry cli which fails in test hook
    "test_integration"
  ];

  pythonImportsCheck = [
    "poetry_dynamic_versioning"
  ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Plugin for Poetry to enable dynamic versioning based on VCS tags";
    homepage = "https://github.com/mtkennerly/poetry-dynamic-versioning";
    changelog = "https://github.com/mtkennerly/poetry-dynamic-versioning/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
