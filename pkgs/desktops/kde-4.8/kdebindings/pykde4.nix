{ kde, kdelibs, python, sip, pyqt4, kdepimlibs, shared_desktop_ontologies,
  boost, lndir }:

let pydir = "lib/python${python.majorVersion}"; in

kde {
  buildInputs = [ python kdepimlibs shared_desktop_ontologies boost ];

  propagatedBuildInputs = [ pyqt4 sip ];

#NIX_CFLAGS_COMPILE = "-I${phonon}/include/phonon";

  patches = [ ./pykde-purity.patch ];

  cmakeFlags = "-DHARDCODE_LIB_PYTHON_PATH=ON";

  preConfigure =
    ''
      # Symlink PyQt into PyKDE.  This is necessary because PyQt looks
      # in its PyQt4/uic/widget-plugins directory for plugins, and KDE
      # needs to install a plugin.
      mkdir -pv $out/${pydir}
      ${lndir}/bin/lndir ${pyqt4}/${pydir} $out/${pydir}
    '';

  meta = {
    description = "Python bindings for KDE";
    kde.name = "pykde4";
  };
}
