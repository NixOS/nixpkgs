{ kde, cmake, kdelibs, qt4, automoc4, phonon
, pythonPackages, sip, pyqt4, pykde4, pycups, rhpl, system_config_printer
, pythonDBus, makeWrapper }:

kde.package rec {
  buildInputs =
    [ cmake qt4 kdelibs automoc4 phonon
      pythonPackages.python pythonPackages.wrapPython
    ] ++ pythonPath;

  pythonPath = [ pyqt4 pykde4 pycups system_config_printer ];

  postInstall =
    ''
      wrapPythonPrograms

      # ‘system-config-printer’ supplies some D-Bus policy that we need.
      mkdir -p $out/nix-support
      echo ${system_config_printer} > $out/nix-support/propagated-user-env-packages
    '';
    
  meta = {
    description = "KDE printer applet";
    longDescription = "Applet to view current print jobs and configure new printers";
    kde = {
      name = "printer-applet";
      module = "kdeutils";
      version = "1.7";
      versionFile = "printer-applet.py";
    };
  };
}
