{ kde, kdelibs, libxml2, libxslt, kdepimlibs
, boost, htmlTidy }:

kde {
  buildInputs =
    [ kdelibs libxml2 libxslt kdepimlibs boost htmlTidy ];

  meta = {
    description = "A KDE link checker";
    homepage = http://klinkstatus.kdewebdev.org;
  };
}
