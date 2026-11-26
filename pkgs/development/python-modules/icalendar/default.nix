{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pythonOlder,
  hatch-vcs,
  hatchling,
  python-dateutil,
  typing-extensions,
  tzdata,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "icalendar";
  version = "7.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6fvSrE1P4wMT8eJH5I7rcE3P7tGlBVNHaYwfvCPEJ6c=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    python-dateutil
    tzdata
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    # typing.TypeIs arrived in Python 3.13.
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "icalendar" ];

  disabledTests = [
    # AssertionError: assert {'Atlantic/Jan_Mayen'} == {'Arctic/Longyearbyen'}
    "test_dateutil_timezone_is_matched_with_tzname"
    "test_docstring_of_python_file"
  ];

  enabledTestPaths = [ "src/icalendar" ];

  meta = {
    description = "Parser/generator of iCalendar files";
    homepage = "https://github.com/collective/icalendar";
    changelog = "https://github.com/collective/icalendar/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ iamanaws ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "icalendar";
  };
})
