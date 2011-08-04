{ kde, cmake, kdelibs, qt4, automoc4, phonon, libxml2, libxslt, kdepimlibs
, boost, htmlTidy }:

kde.package {
  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon libxml2 libxslt kdepimlibs boost htmlTidy ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
    kde = {
      name = "klinkstatus";
      module = "kdewebdev";
      version = "0.7.0";
      versionFile = "src/main.cpp";
    };
  };
}
