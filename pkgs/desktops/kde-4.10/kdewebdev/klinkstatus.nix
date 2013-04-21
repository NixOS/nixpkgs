{ kde, kdelibs, libxml2, libxslt, kdepimlibs, nepomuk_core, htmlTidy, boost }:

kde {
#todo: ruby is not found. needed for some example scripts
  buildInputs =
    [ kdelibs kdepimlibs htmlTidy nepomuk_core boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
