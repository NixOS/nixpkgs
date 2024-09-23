{
  lib,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  freezegun,
  humanize,
  pendulum,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
  snaptime,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "maya";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "maya";
    rev = "refs/tags/v${version}";
    hash = "sha256-4fUyUqVQk/AcQL3xMnU1cQlF5yiD/N9NPAsUPuDTTNY=";
  };

  postPatch = ''
    # function was made private in humanize
    substituteInPlace maya/core.py \
      --replace-fail "humanize.time.abs_timedelta" "humanize.time._abs_timedelta"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dateparser
    humanize
    pendulum
    pytz
    snaptime
    tzlocal
  ];

  nativeCheckInputs = [
    freezegun
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "maya" ];

  disabledTests = [
    # https://github.com/timofurrer/maya/issues/202
    "test_parse_iso8601"
  ];

  meta = with lib; {
    description = "Datetimes for Humans";
    homepage = "https://github.com/timofurrer/maya";
    changelog = "https://github.com/timofurrer/maya/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
