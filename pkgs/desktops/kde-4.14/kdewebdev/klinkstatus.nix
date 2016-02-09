{ kde, kdelibs, libxml2, libxslt, kdepimlibs, html-tidy, boost }:

kde {

# todo: ruby19 is not found by the build system. not linking against ruby18 due to it being too old

  postPatch = ''
    substituteInPlace klinkstatus/src/tidy/tidyx.h \
      --replace buffio.h tidybuffio.h
  '';

  buildInputs = [ kdelibs kdepimlibs html-tidy boost ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
