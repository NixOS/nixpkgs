{ kde, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

kde.package rec {
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  prePatch = ''
      find .. -name CMakeLists.txt | xargs sed -i -e "s@DESTINATION \''${KDE4_DBUS_INTERFACES_DIR}@DESTINATION \''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/@"
  '';

  src = fetchurl {
    url = "mirror://kde/stable/kdepim-${meta.kde.version}/src/${meta.kde.module}-${meta.kde.version}.tar.bz2";
    sha256 = "029a0i83b2yrc1xn9as7gc9rakpxjh5cjmqcmhrrj0xwalqz490n";
  };

  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    kde.module = "kdepim-runtime";
  };
}
