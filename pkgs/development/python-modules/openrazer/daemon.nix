{ buildPythonApplication
, isPy3k
, daemonize
, dbus-python
, fetchFromGitHub
, fetchpatch
, gobject-introspection
, gtk3
, makeWrapper
, pygobject3
, pyudev
, setproctitle
, stdenv
, wrapGAppsHook
}:

let
  common = import ./common.nix { inherit stdenv fetchFromGitHub; };
in
buildPythonApplication (common // rec {
  pname = "openrazer_daemon";

  disabled = !isPy3k;

  sourceRoot = "source/daemon";

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

  postBuild = ''
    DESTDIR="$out" PREFIX="" make install manpages
  '';

  meta = common.meta // {
    description = "An entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
