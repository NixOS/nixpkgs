{kde, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, qca2
, kdebindings, twisted, python, pyqt4, sip, makeWrapper }:

kde.package {

# TODO: ggz
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 qca2
    kdebindings twisted python pyqt4 sip makeWrapper ];

  meta = {
    description = "KDE Games";
    license = "GPL";
    kde.name = "kdegames";
  };
}
