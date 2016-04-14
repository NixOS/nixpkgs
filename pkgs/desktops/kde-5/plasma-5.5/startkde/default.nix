{ stdenv, lib, runCommand
, dbus
, gnugrep, gnused
, kconfig, kinit, kservice
, plasma-workspace
, qttools
, socat
, xmessage, xprop, xsetroot
}:

let

  env = {
    inherit (stdenv) shell;
    paths = [
      dbus.tools
      gnugrep gnused
      kconfig kinit kservice
      plasma-workspace
      qttools
      socat
      xmessage xprop xsetroot
    ];
  };

in runCommand "startkde" env ''
  prefix_PATH=
  for pkg in $paths; do
    addToSearchPath prefix_PATH "$pkg/bin"
    addToSearchPath prefix_PATH "$pkg/lib/libexec"
    addToSearchPath prefix_PATH "$pkg/lib/libexec/kf5"
  done
  substitute ${./startkde.sh} "$out" --subst-var shell --subst-var prefix_PATH
  chmod +x "$out"
''
