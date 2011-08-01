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
    url = "mirror://kde/stable/kdepim-${meta.kde.version}/src/${meta.kde.name}-${meta.kde.version}.tar.bz2";
    sha256 = "0w99jv0lzajmz9gvgss8gkgffm0lpqv3r6pzfsnqhrdhcf6h853y";
  };

  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    kde = {
      name = "kdepim-runtime";
      version = "4.4.9";
    };
  };
}
