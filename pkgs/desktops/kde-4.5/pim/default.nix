{ kde, cmake, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver, kdelibs, kdepimlibs, kdepim_runtime
, automoc4, akonadi, qca2}:

kde.package {

  buildInputs = [ cmake boost gpgme libassuan libgpgerror libxslt
    shared_mime_info libXScrnSaver kdelibs kdepimlibs automoc4 akonadi ];
  prePatch = ''
      find .. -name CMakeLists.txt | xargs sed -i -e "s@DESTINATION \''${KDE4_DBUS_INTERFACES_DIR}@DESTINATION \''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/@"
  '';
  postInstall = ''
      mkdir -p $out/nix-support/
      echo ${akonadi} ${kdepimlibs} ${kdepim_runtime} > $out/nix-support/propagated-user-env-packages
  '';
  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer
    '';
    license = "GPL";
    homepage = http://pim.kde.org;
    kde = rec {
      name = "kdepim";
      version = "4.4.6";
      subdir = "kdepim-${version}/src";
    };
  };
}
