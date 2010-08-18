{ kdePackage, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, ruby, htmlTidy, zlib }:

kdePackage {
  pn = "kdewebdev";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs
    automoc4 htmlTidy ruby zlib ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
  };
}
