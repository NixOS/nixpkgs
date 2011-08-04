{ kde, cmake, qt4, automoc4, kdelibs, phonon, python, sip, pyqt4
, soprano, kdepimlibs, shared_desktop_ontologies, boost, lndir }:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon python sip pyqt4 soprano
      kdepimlibs shared_desktop_ontologies boost lndir
    ];

  NIX_CFLAGS_COMPILE = "-I${phonon}/include/phonon";

  preConfigure =
    ''
      substituteInPlace CMakeLists.txt \
        --replace '{SIP_DEFAULT_SIP_DIR}' '{CMAKE_INSTALL_PREFIX}/share/sip'

      # Use an absolute path to open libpython.so.
      substituteInPlace kpythonpluginfactory/kpythonpluginfactory.cpp \
        --replace LIB_PYTHON \"$(echo ${python}/lib/libpython*.so.*)\"

      # Symlink PyQt into PyKDE.  This is necessary because PyQt looks
      # in its PyQt4/uic/widget-plugins directory for plugins, and KDE
      # needs to install a plugin.
      mkdir -p $out/lib/python2.7
      lndir ${pyqt4}/lib/python2.7 $out/lib/python2.7
    '';

  meta = {
    description = "Python bindings for KDE";
    kde.name = "pykde4";
  };
}
