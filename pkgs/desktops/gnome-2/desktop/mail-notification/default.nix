{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, glib, gnome2, dbus-glib, gmime, libnotify, libgnome-keyring, openssl, cyrus_sasl, gnonlin, sylpheed, gob2, gettext, intltool, libxml2, hicolor-icon-theme, tango-icon-theme }:

stdenv.mkDerivation rec {
  rev = "9ae8768";
  version = "5.4";
  name = "mail-notification-${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "epienbroek";
    repo = "mail-notification";
    sha256 = "1slb7gajn30vdaq0hf5rikwdly1npmg1cf83hpjs82xd98knl13d";
  };

  nativeBuildInputs = [ pkgconfig ];
   buildInputs = [ glib dbus-glib gmime libnotify libgnome-keyring openssl cyrus_sasl gnonlin sylpheed gob2 gettext intltool gnome2.GConf gnome2.libgnomeui dbus-glib gmime libnotify gnome2.gnome-keyring gnome2.scrollkeeper libxml2 gnome2.gnome_icon_theme hicolor-icon-theme tango-icon-theme ];

  prePatch = ''
    sed -i  -e '/jb_rule_set_install_message/d' -e '/jb_rule_add_install_command/d' jbsrc/jb.c

    # currently disable the check for missing sheme until a better solution
    # is found; needed, because otherwise the application doesn't even start
    # and fails saying it unable to find gconf scheme values.
    sed -i -e 's/(schema_missing)/(!schema_missing)/g' src/mn-conf.c
  '';

  patches = [
    ./patches/mail-notification-dont-link-against-bsd-compat.patch
  ];

  patchFlags = "-p0";
  NIX_CFLAGS_COMPILE = "-Wno-error";

  preConfigure = "./jb configure prefix=$out";

  postConfigure = ''
    substituteInPlace build/config \
      --replace "omf-dir|string|1|${gnome2.scrollkeeper}/share/omf" "omf-dir|string|1|$out/share/omf" \
      --replace "scrollkeeper-dir|string|1|${gnome2.scrollkeeper}/var/lib/scrollkeeper" "omf-dir|string|1|$out/var/lib/scrollkeeper" \
  '';

  buildPhase = "./jb build";
  installPhase = "./jb install";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tray status icon, which notifies us when new email arrives";
    homepage = http://www.nongnu.org/mailnotify/;
    license = with licenses; [ gpl3 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.eleanor ];
  };
}
