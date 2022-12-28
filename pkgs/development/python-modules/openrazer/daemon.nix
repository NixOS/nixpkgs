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
  pname = "openrazer_daemon";

  disabled = !isPy3k;

  outputs = [ "out" "man" ];

  prePatch = ''
    cd daemon
  '';

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

  postBuild = ''
    DESTDIR="$out" PREFIX="" make install manpages
  '';

  # no tests run
  doCheck = false;

  meta = common.meta // {
    description = "An entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
