{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  gtk3,
  caja,
  dbus-glib,
  libnotify,
  libxml2,
  libcanberra-gtk3,
  apacheHttpdPackages,
  hicolor-icon-theme,
  mate,
  wrapGAppsHook3,
<<<<<<< HEAD
  gitUpdater,
=======
  mateUpdateScript,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  inherit (apacheHttpdPackages) apacheHttpd mod_dnssd;
in
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-user-share";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-user-share-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "iYVgmZkXllE0jkl+8I81C4YIG5expKcwQHfurlc5rjg=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    caja
    dbus-glib
    libnotify
    libcanberra-gtk3
    hicolor-icon-theme
    # Should mod_dnssd and apacheHttpd be runtime dependencies?
    # In gnome-user-share they are not.
    #mod_dnssd
    #apacheHttpd
  ];

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  configureFlags = [
    "--with-httpd=${apacheHttpd.out}/bin/httpd"
    "--with-modules-path=${apacheHttpd}/modules"
    "--with-cajadir=$(out)/lib/caja/extensions-2.0"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-user-share";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "User level public file sharing for the MATE desktop";
    mainProgram = "mate-file-share-properties";
    homepage = "https://github.com/mate-desktop/mate-user-share";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "User level public file sharing for the MATE desktop";
    mainProgram = "mate-file-share-properties";
    homepage = "https://github.com/mate-desktop/mate-user-share";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
