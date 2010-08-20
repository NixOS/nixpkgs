{ kdePackage, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4}:

kdePackage {
  pn = "kdeadmin";
  v = "4.5.0";

  builder = ./builder.sh;

  inherit system_config_printer;

  PYTHONPATH = "${pycups}/lib/python${python.majorVersion}/site-packages";

  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups rhpl system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 ];

  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
  };
}
