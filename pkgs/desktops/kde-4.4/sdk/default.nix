{ stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, shared_mime_info, hunspell
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdesdk-4.4.5.tar.bz2;
    sha256 = "0ykj09ln8rqdsjrix21j4yghzx6rkfkca4q3133sp7h8y56plqrw";
  };
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil shared_mime_info
                  kdelibs kdepimlibs automoc4 phonon strigi hunspell];
  meta = with stdenv.lib; {
    description = "KDE SDK";
    longDescription = "Contains various development utilities such as the Umbrello UML modeler and Cerivisia CVS front-end";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
