{
  lib,
  buildPythonPackage,
  daemonize,
  dbus-python,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  makeWrapper,
  pygobject3,
  pyudev,
  setproctitle,
  setuptools,
  wrapGAppsHook3,
  notify2,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (common // {
  pname = "openrazer-daemon";

  outputs = [
    "out"
    "man"
  ];

  sourceRoot = "${common.src.name}/daemon";

  postPatch = ''
    substituteInPlace openrazer_daemon/daemon.py \
      --replace-fail "plugdev" "openrazer"
  '';

  nativeBuildInputs = [ setuptools ];

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
    mainProgram = "openrazer-daemon";
  };
})
