{ lib
, buildPythonPackage
, dunamai
, fetchFromGitHub
, jinja2
, poetry
, poetry-core
, pytestCheckHook
, pythonOlder
, tomlkit
}:

buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
  version = "0.21.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-g2tMnc62WN2rihQQT4nz0lUVSY0E4gI4QMImBVZ3EKc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dunamai
    jinja2
    poetry
    tomlkit
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # these require network access
    "test_integration.py"
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
