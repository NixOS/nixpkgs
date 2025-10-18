{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "syncall";
  version = "1.8.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "syncall";
    tag = "v${version}";
    hash = "sha256-f9WVZ1gpVG0wvIqoAkeaYBE4QsGXSqrYS4KyHy6S+0Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail 'loguru = "^0.5.3"' 'loguru = "^0.7"' \
    --replace-fail 'PyYAML = "~5.3.1"' 'PyYAML = "^6.0"' \
    --replace-fail 'bidict = "^0.21.2"' 'bidict = "^0.23"' \
    --replace-fail 'typing = "^3.7.4"' '''
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3Packages; [
    bidict
    bubop
    click
    item-synchronizer
    loguru
    python-dateutil
    pyyaml
    rfc3339
    typing
  ];

  optional-dependencies = with python3Packages; {
    asana = [
      asana
    ];
    caldav = [
      caldav
      icalendar
    ];
    fs = [
      xattr
    ];
    gkeep = [
      gkeepapi
    ];
    gcal = [
      google-api-python-client
      google-auth-oauthlib
    ];
    notion-client = [
      notion-client
    ];
    taskw-ng = [
      taskw-ng
    ];
  };

  pythonImportsCheck = [ "syncall" ];

  meta = {
    description = "Bi-directional synchronization between services such as Taskwarrior, Google Calendar, Notion, Asana, and more";
    homepage = "https://github.com/bergercookie/syncall";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
