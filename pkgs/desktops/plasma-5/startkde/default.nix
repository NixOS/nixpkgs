{
  stdenv, lib, runCommand, substituteAll, dbus, gnugrep, gnused, kconfig,
  kinit, kservice, plasma-desktop, plasma-workspace, xmessage, xprop, xrdb,
  xsetroot, qttools,
}:

let

  inherit (lib) getBin getLib;

  script = substituteAll {
    src = ./startkde.sh;
    inherit (stdenv) shell;
    kbuildsycoca5 = "${getBin kservice}/bin/kbuildsycoca5";
    sed = "${getBin gnused}/bin/sed";
    kcheckrunning = "${getBin plasma-workspace}/bin/kcheckrunning";
    xmessage = "${getBin xmessage}/bin/xmessage";
    kstartupconfig5 = "${getBin plasma-workspace}/bin/kstartupconfig5";
    kapplymousetheme = "${getBin plasma-desktop}/bin/kapplymousetheme";
    xsetroot = "${getBin xsetroot}/bin/xsetroot";
    xrdb = "${getBin xrdb}/bin/xrdb";
    ksplashqml = "${getBin plasma-workspace}/bin/ksplashqml";
    qdbus = "${getBin qttools}/bin/qdbus";
    xprop = "${getBin xprop}/bin/xprop";
    qtpaths = "${getBin qttools}/bin/qtpaths";
    dbus_update_activation_environment = "${getBin dbus}/bin/dbus-update-activation-environment";
    start_kdeinit_wrapper = "${getLib kinit}/lib/libexec/kf5/start_kdeinit_wrapper";
    kwrapper5 = "${getBin kinit}/bin/kwrapper5";
    ksmserver = "${getBin plasma-workspace}/bin/ksmserver";
    kreadconfig5 = "${getBin kconfig}/bin/kreadconfig5";
    kdeinit5_shutdown = "${getBin kinit}/bin/kdeinit5_shutdown";
  };

in

runCommand "startkde.sh"
{ preferLocalBuild = true; allowSubstitutes = false; }
''
  cp ${script} $out
  chmod +x $out
''
