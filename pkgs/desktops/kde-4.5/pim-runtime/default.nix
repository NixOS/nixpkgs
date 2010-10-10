{ kde, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

kde.package {
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  prePatch = ''
      find .. -name CMakeLists.txt | xargs sed -i -e "s@DESTINATION \''${KDE4_DBUS_INTERFACES_DIR}@DESTINATION \''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/@"
  '';
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    kde = rec {
      name = "kdepim-runtime";
      version = "4.4.6";
      subdir = "kdepim-${version}/src";
    };
  };
}
