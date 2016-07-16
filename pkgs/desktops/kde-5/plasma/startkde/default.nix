{
  stdenv, lib, runCommand, dbus, qttools, socat, gnugrep, gnused, kconfig,
  kinit, kservice, plasma-workspace, xmessage, xprop, xsetroot, qtbase,
  qtdeclarative, qtgraphicaleffects, qtquickcontrols, qtscript, qtsvg,
  qtx11extras, qtxmlpatterns
}:

let

  env = {
    inherit (stdenv) shell;
    bins = builtins.map (pkg: pkg.out or pkg)
      [
        dbus qttools socat
        gnugrep gnused
        kconfig kinit kservice
        plasma-workspace
        xmessage xprop xsetroot
      ];
    libs = builtins.map (pkg: pkg.out or pkg)
      [
        qtbase qtdeclarative qtgraphicaleffects qtquickcontrols
        qtscript qtsvg qtx11extras qtxmlpatterns
      ];
  };

in runCommand "startkde" env ''

  # Configure PATH variable
  suffixPATH=
  for p in $bins; do
      addToSearchPath suffixPATH "$p/bin"
      addToSearchPath suffixPATH "$p/lib/libexec"
      addToSearchPath suffixPATH "$p/lib/libexec/kf5"
  done

  # Configure Qt search paths
  QT_PLUGIN_PATH=
  QML_IMPORT_PATH=
  QML2_IMPORT_PATH=
  for p in $libs; do
      addToSearchPath QT_PLUGIN_PATH "$p/lib/qt5/plugins"
      addToSearchPath QML_IMPORT_PATH "$p/lib/qt5/imports"
      addToSearchPath QML2_IMPORT_PATH "$p/lib/qt5/qml"
  done

  substitute ${./startkde.sh} "$out" \
      --subst-var shell \
      --subst-var suffixPATH \
      --subst-var QT_PLUGIN_PATH \
      --subst-var QML_IMPORT_PATH \
      --subst-var QML2_IMPORT_PATH
  chmod +x "$out"
''
