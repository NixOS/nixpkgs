{ kde, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, ruby, htmlTidy, zlib }:

kde.package {

  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs
    automoc4 htmlTidy ruby zlib ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    kde = {
      name = "kdewebdev";
      version = "4.5.0";
    };
  };
}
