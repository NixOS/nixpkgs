{ kde, kdelibs, libxml2, libxslt, kdepimlibs, htmlTidy, boost }:

kde {

# todo: ruby19 is not found by the build system. not linking against ruby18 due to it being too old

  buildInputs = [ kdelibs kdepimlibs htmlTidy boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
