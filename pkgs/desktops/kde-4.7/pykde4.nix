{ kde, cmake, qt4, automoc4, kdelibs, phonon, python, sip, pyqt4
, soprano, kdepimlibs, shared_desktop_ontologies, boost }:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon python sip pyqt4 soprano
      kdepimlibs shared_desktop_ontologies boost
    ];

  NIX_CFLAGS_COMPILE = "-I${phonon}/include/phonon";

  preConfigure =
    ''
      substituteInPlace CMakeLists.txt \
        --replace '{SIP_DEFAULT_SIP_DIR}' '{CMAKE_INSTALL_PREFIX}/share/sip'
    '';

  meta = {
    description = "Python bindings for KDE";
    kde.name = "pykde4";
  };
}
