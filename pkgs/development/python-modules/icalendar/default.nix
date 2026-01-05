{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  hatch-vcs,
  hatchling,
  python-dateutil,
  tzdata,
  hypothesis,
  pytestCheckHook,
  sphinxHook,
  sphinx-copybutton,
  pydata-sphinx-theme,
}:

buildPythonPackage rec {
  version = "6.3.2";
  pname = "icalendar";
  pyproject = true;
  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    tag = "v${version}";
    hash = "sha256-EnG6zPaKKTgLw2DxWOyBkxlFuqtURpBlxy1aoZjX/TQ=";
  };

  patches = [
    (replaceVars ./no-dynamic-version.patch {
      inherit version;
    })
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    python-dateutil
    tzdata
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-copybutton
    pydata-sphinx-theme
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert {'Atlantic/Jan_Mayen'} == {'Arctic/Longyearbyen'}
    "test_dateutil_timezone_is_matched_with_tzname"
    "test_docstring_of_python_file"
    # AssertionError: assert $TZ not in set()
    "test_add_missing_timezones_to_example"
  ];

  enabledTestPaths = [ "src/icalendar" ];

  meta = with lib; {
    changelog = "https://github.com/collective/icalendar/blob/${src.tag}/CHANGES.rst";
    description = "Parser/generator of iCalendar files";
    mainProgram = "icalendar";
    homepage = "https://github.com/collective/icalendar";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };
}
