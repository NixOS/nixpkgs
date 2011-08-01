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
    url = "mirror://kde/stable/kdepim-${meta.kde.version}/src/${meta.kde.name}-${meta.kde.version}.tar.bz2";
    sha256 = "0pr1n6k51aadi8fsk7rkv0vrfl4y6llywxjkzci6if7g300yd8r8";
  };

  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer
    '';
    license = "GPL";
    homepage = http://pim.kde.org;
    kde = {
      name = "kdepim";
      version = "4.4.9";
    };
  };
}
