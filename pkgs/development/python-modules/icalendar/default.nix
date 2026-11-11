{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "7.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SrQ5Bfb3ZyUyYYvT9FkUs6pAwx9WGL+DdWTAn1N0RrA=";
  };

  patches = [
    # https://github.com/collective/icalendar/pull/1661
    (fetchpatch2 {
      name = "warn-on-cached-tzid-guess.patch";
      url = "https://github.com/collective/icalendar/commit/0213619845d5ff2525de409d70dd40c0fe1d5f1f.patch?full_index=1";
      hash = "sha256-dkzQp3nsKqdDR2sACe8imYvJyNVJzBfFXpE4gXv5oiY=";
    })
  ];

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
    changelog = "https://github.com/collective/icalendar/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "icalendar";
  };
})
