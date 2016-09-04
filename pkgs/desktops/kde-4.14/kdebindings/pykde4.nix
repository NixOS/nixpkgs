{ kde, kdelibs, pythonPackages, kdepimlibs, shared_desktop_ontologies,
  polkit_qt4, boost, lndir, pkgconfig }:

let
  inherit (pythonPackages) python pyqt4;
  pydir = "lib/python${python.majorVersion}";
in kde {

  patches = [ ./pykde4-gcc-5.patch ];

  # todo: polkit isn't found by the build system

  buildInputs = [
    python kdepimlibs shared_desktop_ontologies
    boost polkit_qt4
  ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ pyqt4 ];

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
  };
}
