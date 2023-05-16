{ lib
, buildPythonPackage
, isPy3k
, daemonize
, dbus-python
, fetchFromGitHub
, gobject-introspection
, gtk3
, makeWrapper
, pygobject3
, pyudev
, setproctitle
, wrapGAppsHook
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (common // {
<<<<<<< HEAD
  pname = "openrazer-daemon";
=======
  pname = "openrazer_daemon";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = !isPy3k;

  outputs = [ "out" "man" ];

<<<<<<< HEAD
  sourceRoot = "${common.src.name}/daemon";
=======
  prePatch = ''
    cd daemon
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace openrazer_daemon/daemon.py --replace "plugdev" "openrazer"
  '';

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

  propagatedBuildInputs = [
    daemonize
    dbus-python
    gobject-introspection
    gtk3
    pygobject3
    pyudev
    setproctitle
  ];

<<<<<<< HEAD
  postInstall = ''
    DESTDIR="$out" PREFIX="" make manpages install-resources install-systemd
=======
  postBuild = ''
    DESTDIR="$out" PREFIX="" make install manpages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # no tests run
  doCheck = false;

  meta = common.meta // {
    description = "An entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
