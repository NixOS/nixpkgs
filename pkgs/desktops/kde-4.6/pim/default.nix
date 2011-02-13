{ kde, fetchurl, cmake, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver, kdelibs, kdepimlibs, kdepim_runtime
, automoc4, akonadi, qca2}:

kde.package rec {

  buildInputs = [ cmake boost gpgme libassuan libgpgerror libxslt
    shared_mime_info libXScrnSaver kdelibs kdepimlibs automoc4 akonadi ];
  prePatch = ''
      find .. -name CMakeLists.txt | xargs sed -i -e "s@DESTINATION \''${KDE4_DBUS_INTERFACES_DIR}@DESTINATION \''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/@"
  '';
  postInstall = ''
      mkdir -p $out/nix-support/
      echo ${akonadi} ${kdepimlibs} ${kdepim_runtime} > $out/nix-support/propagated-user-env-packages
  '';

  src = fetchurl {
    url = "mirror://kde/stable/kdepim-${meta.kde.version}/src/${meta.kde.module}-${meta.kde.version}.tar.bz2";
    sha256 = "02nbdn8s4504ljqz0qylm1jyw4hpg5fjw3vi6sbzm522xvkax4wh";
  };

  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer
    '';
    license = "GPL";
    homepage = http://pim.kde.org;
    kde.module = "kdepim";
  };
}
