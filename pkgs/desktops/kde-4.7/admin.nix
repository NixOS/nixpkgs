{ kde, cmake, qt4, pkgconfig, perl, pythonPackages
, sip, pycups, pygobject, system_config_printer
, kdelibs, automoc4, phonon, kdepimlibs, pykde4
, cups, nettools } @ args:

let

  system_config_printer = args.system_config_printer.override { withGUI = false; };

in

kde.package rec {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon kdepimlibs
      pythonPackages.python
      pycups pykde4 sip pygobject system_config_printer
    ];

  passthru = { inherit system_config_printer; };

  preConfigure =
    ''
      for i in system-config-printer-kde/cmake-modules/FindSystemConfigPrinter.py system-config-printer-kde/system-config-printer-kde.py; do
        substituteInPlace $i \
          --replace /usr/share/system-config-printer ${system_config_printer}/share/system-config-printer \
          --replace /usr/bin/cupstestppd ${cups}/bin/cupstestppd \
          --replace /bin/hostname ${nettools}/bin/hostname
      done
    '';

  postInstall =
    ''
      # Bake the required Python path into the printer configuration program.
      res=
      for i in $(IFS=:; echo $PYTHONPATH); do res="$res''${res:+,} '$i'"; done
      
      sed -i $out/share/apps/system-config-printer-kde/system-config-printer-kde.py \
          -e "1 a import sys\nsys.path = [$res] + sys.path"
      
      mkdir -p $out/nix-support
      echo ${pykde4} > $out/nix-support/propagated-user-env-packages
    '';
    
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    kde.name = "kdeadmin";
  };
}
