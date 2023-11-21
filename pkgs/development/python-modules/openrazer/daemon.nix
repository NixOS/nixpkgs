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
, notify2
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (common // {
  pname = "openrazer-daemon";

  disabled = !isPy3k;

  outputs = [ "out" "man" ];

  sourceRoot = "${common.src.name}/daemon";

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
    notify2
  ];

  postInstall = ''
    DESTDIR="$out" PREFIX="" make manpages install-resources install-systemd
  '';

  # no tests run
  doCheck = false;

  meta = common.meta // {
    description = "An entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
