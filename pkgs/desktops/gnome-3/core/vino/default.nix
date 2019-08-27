{ stdenv
, fetchFromGitLab
, wrapGAppsHook
, pkgconfig
, gnome3
, gtk3
, glib
, intltool
, libXtst
, libnotify
, libsoup
, libsecret
, gnutls
, libgcrypt
, avahi
, zlib
, libjpeg
, libXdamage
, libXfixes
, libXext
, networkmanager
, gnome-common
, libtool
, automake
, autoconf
, telepathySupport ? false
, dbus-glib ? null
, telepathy-glib ? null
}:

stdenv.mkDerivation rec {
  pname = "vino";
  version = "unstable-2019-07-08";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "vino";
    rev = "aed81a798558c8127b765cd4fb4dc726d10f1e21";
    sha256 = "16r4cj5nsygmd9v97nq6d1yhynzak9hdnaprcdbmwfhh0c9w8jv3";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoconf
    automake
    gnome-common
    intltool
    libtool
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    avahi
    glib
    gnome3.adwaita-icon-theme
    gnutls
    gtk3
    libXdamage
    libXext
    libXfixes
    libXtst
    libgcrypt
    libjpeg
    libnotify
    libsecret
    libsoup
    networkmanager
    zlib
  ]
  ++ stdenv.lib.optionals telepathySupport [ dbus-glib telepathy-glib ]
  ;

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postInstall = stdenv.lib.optionalString (!telepathySupport) ''
    rm -f $out/share/dbus-1/services/org.freedesktop.Telepathy.Client.Vino.service
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "vino";
      attrPath = "gnome3.vino";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
