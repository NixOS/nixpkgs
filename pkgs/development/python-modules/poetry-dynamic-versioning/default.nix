{
  lib,
  buildPythonPackage,
  dunamai,
  fetchFromGitHub,
  jinja2,
  poetry-core,
  poetry,
  pytestCheckHook,
  pythonOlder,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
  version = "1.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "poetry-dynamic-versioning";
    tag = "v${version}";
    hash = "sha256-SKVx20RrwhCpdDIc2Pu1oFaXWe2d2GnbJGUX7KqMvo0=";
  };

  nativeBuildInputs = [ poetry-core ];

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

  pythonImportsCheck = [ "poetry_dynamic_versioning" ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Plugin for Poetry to enable dynamic versioning based on VCS tags";
    mainProgram = "poetry-dynamic-versioning";
    homepage = "https://github.com/mtkennerly/poetry-dynamic-versioning";
    changelog = "https://github.com/mtkennerly/poetry-dynamic-versioning/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
