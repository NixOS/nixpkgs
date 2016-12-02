{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, glib, gnome2, dbus_glib, gmime, libnotify, libgnome_keyring, openssl, cyrus_sasl, gnonlin, sylpheed, gob2, gettext, intltool, libxml2, hicolor_icon_theme, tango-icon-theme }:

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

   buildInputs = [ pkgconfig glib dbus_glib gmime libnotify libgnome_keyring openssl cyrus_sasl gnonlin sylpheed gob2 gettext intltool gnome2.GConf gnome2.libgnomeui dbus_glib gmime libnotify gnome2.gnome_keyring gnome2.scrollkeeper libxml2 gnome2.gnome_icon_theme hicolor_icon_theme tango-icon-theme ];

  prePatch = ''
    sed -i  -e '/jb_rule_set_install_message/d' -e '/jb_rule_add_install_command/d' jbsrc/jb.c || die

    # Ensure we never append -Werror
    sed -i -e 's/ -Werror//' jb jbsrc/jb.c || die
  '';

  patches = [
    ./patches/mail-notification-5.4-remove-ubuntu-special-case.patch
  #  ./patches/mail-notification-aarch64.patch
    ./patches/mail-notification-dont-link-against-bsd-compat.patch
  #  ./patches/mail-notification-jb-gcc-format.patch
  ];

  patchFlags = "-p0";

  configurePhase = ''
    ./jb configure
    runHook postConfigure
  '';

  postConfigure = ''
    sed -i -e "/^prefix/c prefix|string|1|$out" \
           -e 's/^pkgdatadir.*/pkgdatadir|string|0|$datadir/g' \
           build/config

    # currently disable the check for missing sheme until a better solution
    # is found; needed, because otherwise the application doesn't even start
    # and fails saying it unable to find gconf scheme values.
    sed -i -e 's/(schema_missing)/(!schema_missing)/g' src/mn-conf.c
  '';


  buildPhase = ''
    ./jb build
  '';

  # the "./jb install" tries to install directly to nix store, which is not
  # writable, so we have to copy the files ourselves
  installPhase = ''
    #GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1" ./jb install

    # create directories
    mkdir -p $out/{bin,lib,libexec,share,etc,var}

    # copy executable
    cp ./build/src/mail-notification $out/bin/

    # copy icons
    #mkdir -p $out/share/icons/hicolor
    cp -r art/* $out/share/

    # copy schemas
    mkdir -p $out/etc/gconf/schemas/
    #GCONF_CONFIG_SOURCE="xml:merged:${gnome2.GConf}/etc/gconf/gconf.xml.defaults" ${gnome2.GConf}/bin/gconftool-2 --makefile-install-rule data/mail-notification.schemas.in.in
    cp data/mail-notification.schemas.in.in $out/etc/gconf/schemas/

    # copy properties dialogs
    cp ui/* $out/share/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tray status icon, which notifies us when new email arrives";
    homepage = "http://www.nongnu.org/mailnotify/";
    license = "GPL-3";
    platforms = platforms.unix;
    maintainers = [ maintainers.eleanor ];
  };
}
