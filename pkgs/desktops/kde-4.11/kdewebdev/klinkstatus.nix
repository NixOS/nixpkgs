{ kde, kdelibs, libxml2, libxslt, kdepimlibs, htmlTidy, boost, ruby18 }:

kde {

  buildInputs = [ kdelibs kdepimlibs ruby18 htmlTidy boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
