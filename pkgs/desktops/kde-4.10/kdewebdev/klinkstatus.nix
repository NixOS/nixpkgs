{ kde, kdelibs, libxml2, libxslt, kdepimlibs, htmlTidy, boost }:

kde {
#todo: ruby is not found. needed for some example scripts
  buildInputs =
    [ kdelibs kdepimlibs htmlTidy boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
