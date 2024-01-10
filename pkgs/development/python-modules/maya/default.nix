{ lib
, fetchFromGitHub
, buildPythonPackage

# build-system
, setuptools

# dependencies
, dateparser
, humanize
, tzlocal
, pendulum
, snaptime
, pytz

# tests
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "maya";
  version = "0.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kennethreitz";
    repo = "maya";
    rev = "refs/tags/v${version}";
    hash = "sha256-4fUyUqVQk/AcQL3xMnU1cQlF5yiD/N9NPAsUPuDTTNY=";
  };

  postPatch = ''
    # function was made private in humanize
    substituteInPlace maya/core.py \
      --replace "humanize.time.abs_timedelta" "humanize.time._abs_timedelta"
  '';

  nativeBuildInputs = [
    setuptools
  ];

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
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Datetimes for Humans";
    homepage = "https://github.com/kennethreitz/maya";
    license = licenses.mit;
  };
}
