{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "syncall";
  version = "1.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "syncall";
    rev = "v${version}";
    hash = "sha256-RkLAtXjr56l9NUile7LfpZUxGj99WaAhKGDv7HPNMBw=";
  };

  patches = [
    # https://github.com/bergercookie/syncall/pull/98
    ./build-using-poetry-core.patch
  ];

  nativeBuildInputs = [
    python3.pkgs.poetry-core
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
    notion-client
    # taskwarrior optional-dep
    taskw
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
