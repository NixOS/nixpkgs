{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "syncall";
  version = "1.8.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "syncall";
    rev = "v${version}";
    hash = "sha256-f9WVZ1gpVG0wvIqoAkeaYBE4QsGXSqrYS4KyHy6S+0Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail 'loguru = "^0.5.3"' 'loguru = "^0.7"' \
    --replace-fail 'PyYAML = "~5.3.1"' 'PyYAML = "^6.0"' \
    --replace-fail 'bidict = "^0.21.2"' 'bidict = "^0.23"' \
    --replace-fail 'typing = "^3.7.4"' '''
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bidict
    bubop
    click
    item-synchronizer
    loguru
    python-dateutil
    pyyaml
    rfc3339
    typing

    # asana optional-dep
    asana
    # caldav optional-dep
    caldav
    icalendar
    # fs optional-dep
    xattr
    # gkeep optional-dep
    # gkeepapi is unavailable in nixpkgs
    # google optional-dep
    google-api-python-client
    google-auth-oauthlib
    # notion optional-dep
    # FIXME: notion-client -- broken, doesn't build.
    # taskwarrior optional-dep
    taskw-ng
  ];

  postInstall = ''
    # We do not support gkeep
    rm $out/bin/tw_gkeep_sync
  '';

  pythonImportsCheck = [ "syncall" ];

  meta = with lib; {
    description = "Bi-directional synchronization between services such as Taskwarrior, Google Calendar, Notion, Asana, and more";
    homepage = "https://github.com/bergercookie/syncall";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
