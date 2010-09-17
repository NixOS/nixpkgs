{ kde, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4}:

kde.package {

  builder = ./builder.sh;

  inherit system_config_printer;

  # TODO: split, check which packages work on nixos

  PYTHONPATH = "${pycups}/lib/python${python.majorVersion}/site-packages";

  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups rhpl system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 ];

  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    kde = {
      name = "kdeadmin";
      version = "4.5.1";
    };
  };
}
