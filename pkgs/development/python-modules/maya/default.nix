{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, dateparser
, humanize
, pendulum
, pytz
, snaptime
, tzlocal
, pytestCheckHook
, freezegun
, pytest-mock
}:

buildPythonPackage rec {
  pname = "maya";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kennethreitz";
    repo = "maya";
    rev = "refs/tags/v${version}";
    hash = "sha256-4fUyUqVQk/AcQL3xMnU1cQlF5yiD/N9NPAsUPuDTTNY=";
  };

  # fix humanize incompatibility
  # https://github.com/timofurrer/maya/commit/d9cd563d1b1ba16bcff4dacb4ef49edd4e32fd1d.patch
  # ^ does not apply on 0.6.1
  postPatch = ''
    substituteInPlace maya/core.py \
      --replace  \
        "humanize.time.abs_timedelta" \
        "humanize.time._abs_timedelta"
  '';

  propagatedBuildInputs = [
    dateparser
    humanize
    pendulum
    pytz
    snaptime
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
    pytest-mock
  ];

  meta = with lib; {
    description = "Datetimes for Humans";
    homepage = "https://github.com/kennethreitz/maya";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
