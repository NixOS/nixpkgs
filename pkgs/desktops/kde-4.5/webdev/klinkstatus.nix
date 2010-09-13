{ kde, cmake, kdelibs, automoc4, libxml2, libxslt, kdepimlibs, boost, htmlTidy,
  ruby }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt kdepimlibs boost
    htmlTidy ruby ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
    kde = {
      name = "klinkstatus";
      module = "kdewebdev";
      version = "0.7.0";
      release = "4.5.1";
    };
  };
}
