{ stdenv, fetchurl, pkgconfig, libxml2, gnome3, dconf, nautilus
, gtk3, gsettings-desktop-schemas, vte, gettext, which, libuuid, vala
, desktop-file-utils, itstool, wrapGAppsHook, glib, pcre2
, libxslt, docbook-xsl-nons }:

stdenv.mkDerivation rec {
  pname = "gnome-terminal";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1xalmvic4h5dgw77h899h6nzyg56bgm1vgk92kbgzil3nflcf3qa";
  };

  buildInputs = [
    gtk3 gsettings-desktop-schemas vte libuuid dconf
    # For extension
    nautilus
  ];

  nativeBuildInputs = [
    pkgconfig gettext itstool which libxml2 libxslt docbook-xsl-nons
    vala desktop-file-utils wrapGAppsHook pcre2
  ];

  # Silly ./configure, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  postPatch = ''
    substituteInPlace configure --replace '$(eval echo $(eval echo $(eval echo ''${dbusinterfacedir})))/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
    substituteInPlace src/Makefile.in --replace '$(dbusinterfacedir)/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
  '';

  configureFlags = [ "--disable-migration" ]; # TODO: remove this with 3.30

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-terminal";
      attrPath = "gnome3.gnome-terminal";
    };
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNOME Terminal Emulator";
    homepage = "https://wiki.gnome.org/Apps/Terminal";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
  };
}
