{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, dunamai
, jinja2
, markupsafe
, poetry-core
, pytest
, tomlkit
}:
buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
  version = "0.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J/93BFyp+XBy9TRAzAM64ZcMurHxcXDTukOGJE5yvBk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    dunamai
    tomlkit
    jinja2
    markupsafe
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # these require .git, but leaveDotGit = true doesn't help
    "test__get_version__defaults"
    "test__get_version__format_jinja"
  ];

  pythonImportsCheck = [ "poetry_dynamic_versioning" ];

  meta = with lib; {
    description = "Plugin for Poetry to enable dynamic versioning based on VCS tags";
    homepage = "https://github.com/mtkennerly/poetry-dynamic-versioning";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
