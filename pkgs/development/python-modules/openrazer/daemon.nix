{
  lib,
  buildPythonPackage,
  daemonize,
  dbus-python,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  pygobject3,
  pyudev,
  setproctitle,
  setuptools,
  wrapGAppsNoGuiHook,
  notify2,
  glib,
  libnotify,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
buildPythonPackage (
  common
  // {
    pname = "openrazer-daemon";

    outputs = [
      "out"
      "man"
    ];

    sourceRoot = "${common.src.name}/daemon";

    postPatch = ''
      substituteInPlace openrazer_daemon/daemon.py \
        --replace-fail "plugdev" "openrazer"
      patchShebangs run_openrazer_daemon.py
      substituteInPlace run_openrazer_daemon.py \
        --replace-fail "/usr/share" "$out/share"
    '';

    nativeBuildInputs = [
      setuptools
      wrapGAppsNoGuiHook
      gobject-introspection
    ];

    buildInputs = [
      glib
      gtk3
    ];

    dependencies = [
      daemonize
      dbus-python
      pygobject3
      pyudev
      setproctitle
      notify2
      libnotify
    ];

    postInstall = ''
      DESTDIR="$out" PREFIX="" make manpages install-resources install-systemd
    '';

    # no tests run
    doCheck = false;

    dontWrapGApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';

    meta = common.meta // {
      description = "Entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
      mainProgram = "openrazer-daemon";
    };
  }
)
