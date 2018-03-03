{ stdenv, fetchurl, pkgconfig, libxml2, gnome3
, gnome-doc-utils, intltool, which, libuuid, vala
, desktop-file-utils, itstool, wrapGAppsHook, appdata-tools }:

stdenv.mkDerivation rec {
  name = "gnome-terminal-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "3a9ba414a814569476515275ad303d8056f296b2669234447712559aa97005b0";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-terminal"; attrPath = "gnome3.gnome-terminal"; };
  };

  buildInputs = [ gnome3.gtk gnome3.gsettings-desktop-schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool gnome3.nautilus ];

  nativeBuildInputs = [ pkgconfig intltool gnome-doc-utils which libuuid libxml2
                        vala desktop-file-utils wrapGAppsHook ];

  # Silly ./configure, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  postPatch = ''
    substituteInPlace configure --replace '$(eval echo $(eval echo $(eval echo ''${dbusinterfacedir})))/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
    substituteInPlace src/Makefile.in --replace '$(dbusinterfacedir)/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
  '';

  # FIXME: enable for gnome3
  configureFlags = [ "--disable-migration" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNOME Terminal Emulator";
    homepage = https://wiki.gnome.org/Apps/Terminal/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
