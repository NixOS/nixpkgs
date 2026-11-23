{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  icalendar,
  rich,
  typer,
  x-wr-timezone,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "mergecal";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mergecal";
    repo = "python-mergecal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HWUZ9MJJMTqDzCJiqt/q7YXDM9Sp9i1qcdBxheZyfrg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    icalendar
    rich
    typer
    x-wr-timezone
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mergecal" ];

  meta = {
    description = "Merge multiple iCalendar feeds into one";
    homepage = "https://mergecal.readthedocs.io/en/latest/";
    changelog = "https://github.com/mergecal/python-mergecal/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "mergecal";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ erictapen ];
    teams = with lib.teams; [ ngi ];
  };
})
