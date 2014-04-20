{ kde, kdelibs, libxml2, libxslt, kdepimlibs, htmlTidy, boost }:

kde {

  buildInputs = [ kdelibs kdepimlibs htmlTidy boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
