{ kde, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, qca2
, twisted, pythonPackages, pyqt4, sip, makeWrapper, phonon, pykde4 }:

kde.package rec {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon shared_mime_info qca2
      pythonPackages.python pythonPackages.wrapPython
    ] ++ pythonPath;

  pythonPath =
    [ pythonPackages.twisted pyqt4 pykde4 ];
    
  # TODO: ggz

  postInstall =
    ''
      wrapPythonPrograms
    '';

  meta = {
    description = "KDE Games";
    license = "GPL";
    kde.name = "kdegames";
  };
}
