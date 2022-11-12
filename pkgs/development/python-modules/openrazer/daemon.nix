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
buildPythonPackage (common // rec {
  pname = "openrazer_daemon";

  disabled = !isPy3k;

  outputs = [ "out" "man" ];

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

  prePatch = ''
    cd daemon
  '';

  postPatch = ''
    substituteInPlace openrazer_daemon/daemon.py --replace "plugdev" "openrazer"
  '';

  postBuild = ''
    DESTDIR="$out" PREFIX="" make install manpages
  '';

  meta = common.meta // {
    description = "An entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
