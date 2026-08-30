{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatch-vcs,
  hatchling,
  python-dateutil,
  typing-extensions,
  tzdata,
  hypothesis,
  pyprojectVersionPatchHook,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  version = "7.2.2";
  pname = "icalendar";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QDxyMotlG50khBP9luRwoXa9YyZ5qOA/vbdHMwFXv3g=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    hatch-vcs
    hatchling
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
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert {'Atlantic/Jan_Mayen'} == {'Arctic/Longyearbyen'}
    "test_dateutil_timezone_is_matched_with_tzname"
    "test_docstring_of_python_file"
  ];

  enabledTestPaths = [ "src/icalendar" ];

  meta = {
    changelog = "https://github.com/collective/icalendar/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Parser/generator of iCalendar files";
    mainProgram = "icalendar";
    homepage = "https://github.com/collective/icalendar";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ olcai ];
  };
})
