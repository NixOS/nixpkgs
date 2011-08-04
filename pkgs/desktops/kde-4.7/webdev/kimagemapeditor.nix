{ kde, cmake, kdelibs, qt4, automoc4, phonon, libxml2, libxslt }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon libxml2 libxslt ];

  meta = {
    description = "An HTML imagemap editor";
    homepage = http://www.nongnu.org/kimagemap/;
    kde = {
      name = "kimagemapeditor";
      module = "kdewebdev";
      version = "3.9.0";
      versionFile = "version.h";
    };
  };
}
