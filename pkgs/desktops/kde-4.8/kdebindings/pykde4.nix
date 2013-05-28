{ kde, kdelibs, python, sip, pyqt4, kdepimlibs, shared_desktop_ontologies,
  boost, lndir }:

let pydir = "lib/python${python.majorVersion}"; in

kde {
  buildInputs = [ python kdepimlibs shared_desktop_ontologies boost ];

  propagatedBuildInputs = [ pyqt4 sip ];

  patches = [ ./pykde4-hardcode-lib-python.patch ./pykde4-new-sip.patch ];

  cmakeFlags = "-DHARDCODE_LIB_PYTHON_PATH=ON ";

  preConfigure =
    ''
      # Symlink PyQt into PyKDE.  This is necessary because PyQt looks
      # in its PyQt4/uic/widget-plugins directory for plugins, and KDE
      # needs to install a plugin.
      mkdir -pv $out/${pydir}
      ${lndir}/bin/lndir ${pyqt4}/${pydir} $out/${pydir}
      cmakeFlagsArray=( "-DSIP_DEFAULT_SIP_DIR=$prefix/share/sip" )
    '';

  meta = {
    description = "Python bindings for KDE";
    kde.name = "pykde4";
  };
}
