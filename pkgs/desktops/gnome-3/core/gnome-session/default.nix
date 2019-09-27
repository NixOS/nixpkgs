{ fetchurl, stdenv, substituteAll, meson, ninja, pkgconfig, gnome3, glib, gtk3, gsettings-desktop-schemas
, gnome-desktop, dbus, json-glib, libICE, xmlto, docbook_xsl, docbook_xml_dtd_412, python3
, libxslt, gettext, makeWrapper, systemd, xorg, epoxy, gnugrep, bash, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gnome-session";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qkdwvj6w33h8csq9mhjbf10f0v5g0sgabyfg1bgp75z0br76si0";
  };

  patches = [
    # Fix debug spam when using systemd session
    # https://gitlab.gnome.org/GNOME/gnome-session/issues/31
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-session/commit/adfdf7f64f08fc07325f9332e9eba46974cc30ee.patch";
      sha256 = "0vjg77gpj3k63a5ffhsvv5m30lbj6cab35lhl4gpqxg4j2j3yy7y";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-session/commit/b7b24627485c520f873db4e918e217a76ededd8c.patch";
      sha256 = "1d8pw8q423wvv0cd32p0yf52vlfj7w1if2gljqvarcm2n1m0pdxj";
    })

    (substituteAll {
      src = ./fix-paths.patch;
      gsettings = "${glib.bin}/bin/gsettings";
      dbusLaunch = "${dbus.lib}/bin/dbus-launch";
      grep = "${gnugrep}/bin/grep";
      bash = "${bash}/bin/bash";
    })
  ];

  mesonFlags = [ "-Dsystemd=true" ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext makeWrapper
    xmlto libxslt docbook_xsl docbook_xml_dtd_412 python3
    dbus # for DTD
  ];

  buildInputs = [
    glib gtk3 libICE gnome-desktop json-glib xorg.xtrans gnome3.adwaita-icon-theme
    gnome3.gnome-settings-daemon gsettings-desktop-schemas systemd epoxy
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  # `bin/gnome-session` will reset the environment when run in wayland, we
  # therefor wrap `libexec/gnome-session-binary` instead which is the actual
  # binary needing wrapping
  preFixup = ''
    wrapProgram "$out/libexec/gnome-session-binary" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome3.gnome-shell}/share"\
      --suffix XDG_CONFIG_DIRS : "${gnome3.gnome-settings-daemon}/etc/xdg"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-session";
      attrPath = "gnome3.gnome-session";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME session manager";
    homepage = https://wiki.gnome.org/Projects/SessionManagement;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
