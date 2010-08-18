{ kdePackage, binutils, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr,
  aprutil , shared_mime_info, hunspell , kdelibs, kdepimlibs, automoc4,
  kdebindings, strigi, kdebase, libtool, antlr}:

kdePackage {
  pn = "kdesdk";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion aprutil apr
    shared_mime_info kdelibs kdepimlibs automoc4 strigi hunspell kdebindings
    kdebase libtool binutils antlr ];

  patches = [ ./find-svn.patch ];

#cmakeFlags = "-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=ON -DBUILD_kioslave=ON";
  meta = {
    description = "KDE SDK";
    longDescription = "Contains various development utilities such as the Umbrello UML modeler and Cerivisia CVS front-end";
    license = "GPL";
  };
}
