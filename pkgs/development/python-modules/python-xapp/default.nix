{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  meson,
  ninja,
  psutil,
  pygobject3,
  gtk3,
  gobject-introspection,
  xapp,
  polkit,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "python-xapp";
  version = "3.0.2";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    hash = "sha256-+wN4BYAS7KYQT0vhyOSdyrJpOhGyv+2FAloClgZOyH0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  propagatedBuildInputs = [
    psutil
    pygobject3
    gtk3
    gobject-introspection
    xapp
    polkit
  ];

  postPatch = ''
    substituteInPlace "xapp/os.py" \
      --replace-fail "/usr/bin/pkexec" "${polkit}/bin/pkexec"

    # We actually want the localedir provided by the caller.
    substituteInPlace "xapp/util/__init__.py" \
      --replace-fail "/usr/share/locale" "/run/current-system/sw/share/locale"
  '';

  doCheck = false;
  pythonImportsCheck = [ "xapp" ];

  passthru = {
    updateScript = gitUpdater { ignoredVersions = "^master.*"; };
    skipBulkUpdate = true; # This should be bumped as part of Cinnamon update.
  };

  meta = {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
