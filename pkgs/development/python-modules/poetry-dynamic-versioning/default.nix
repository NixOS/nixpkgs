{ lib
, buildPythonPackage
, dunamai
, fetchFromGitHub
, jinja2
, markupsafe
, poetry-core
, poetry
, pytestCheckHook
, pythonOlder
, tomlkit
}:

buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
  version = "0.21.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LdcjzfOiKar0BCdU7W+N5adErdk/NOUf+FzeaMlfn3w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dunamai
    jinja2
    markupsafe
    tomlkit
  ];

  checkInputs = [
    pytestCheckHook
    poetry
  ];

  # virtualenv: error: argument dest: the destination . is not write-able at /
  doCheck = false;

  disabledTests = [
    # these require .git, but leaveDotGit = true doesn't help
    "test__get_version__defaults"
    "test__get_version__format_jinja"
  ];

  pythonImportsCheck = [
    "poetry_dynamic_versioning"
  ];

  meta = with lib; {
    description = "Plugin for Poetry to enable dynamic versioning based on VCS tags";
    homepage = "https://github.com/mtkennerly/poetry-dynamic-versioning";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
