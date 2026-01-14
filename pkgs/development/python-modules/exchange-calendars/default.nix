{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pandas,
  korean-lunar-calendar,
  toolz,
  pyluach,

  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "exchange-calendars";
  version = "4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gerrymanoim";
    repo = "exchange_calendars";
    tag = version;
    hash = "sha256-qGQ2XcA4jlT4bCWZsVKQ37okBbQlIHXLyxdzDxfBwGw=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    korean-lunar-calendar
    toolz
    pandas
    pyluach
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ hypothesis ];

  pythonImportsCheck = [ "exchange_calendars" ];

  disabledTests = [ "test_xphs_calendar.py" ];

  meta = with lib; {
    description = "Library for defining and querying calendars for security exchanges";
    homepage = "https://github.com/gerrymanoim/exchange_calendars";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thardin ];
  };
}
