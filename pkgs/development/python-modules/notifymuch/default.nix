{ lib
, buildPythonApplication
, isPy3k
, fetchFromGitHub
, notmuch
, pygobject3
, gobject-introspection
, libnotify
, wrapGAppsHook
, gtk3
}:

buildPythonApplication rec {
  pname = "notifymuch";
  version = "0.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "kspi";
    repo = "notifymuch";
    # https://github.com/kspi/notifymuch/issues/11
    rev = "9d4aaf54599282ce80643b38195ff501120807f0";
    sha256 = "1lssr7iv43mp5v6nzrfbqlfzx8jcc7m636wlfyhhnd8ydd39n6k4";
  };

  propagatedBuildInputs = [
    notmuch
    pygobject3
    libnotify
    gtk3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  strictDeps = false;

  meta = with lib; {
    description = "Display desktop notifications for unread mail in a notmuch database";
    homepage = "https://github.com/kspi/notifymuch";
    maintainers = with maintainers; [ arjan-s ];
    license = licenses.gpl3;
  };
}
