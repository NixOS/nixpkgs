{
  config,
  stdenv,
  pkgs,
  lib,
}:

lib.makeScope pkgs.newScope (
  self: with self; {
  }
)
// lib.optionalAttrs config.allowAliases {
  # added 2024-12-02
  glib = throw "gnome2.glib has been removed, please use top-level glib";
  glibmm = throw "gnome2.glibmm has been removed, please use top-level glibmm";
  atk = throw "gnome2.atk has been removed, please use top-level atk";
  atkmm = throw "gnome2.atkmm has been removed, please use top-level atkmm";
  cairo = throw "gnome2.cairo has been removed, please use top-level cairo";
  pango = throw "gnome2.pango has been removed, please use top-level pango";
  pangomm = throw "gnome2.pangomm has been removed, please use top-level pangomm";
  gtkmm2 = throw "gnome2.gtkmm2 has been removed, please use top-level gtkmm2";
  libcanberra-gtk2 = throw "gnome2.libcanberra-gtk2 has been removed, please use top-level libcanberra-gtk2";
  libsoup = throw "gnome2.libsoup has been removed, please use top-level libsoup_2_4";
  libwnck2 = throw "gnome2.libwnck2 has been removed, please use top-level libwnck2";
  gtk-doc = throw "gnome2.gtk-doc has been removed, please use top-level gtk-doc";
  gnome-doc-utils = throw "gnome2.gnome-doc-utils has been removed, please use top-level gnome-doc-utils";
  gvfs = throw "gnome2.gvfs has been removed, please use top-level gvfs";
  gtk = throw "gnome2.gtk has been removed, please use top-level gtk2";
  gtkmm = throw "gnome2.gtkmm has been removed, please use top-level gtkmm2";
  gtkdoc = throw "gnome2.gtkdoc has been removed, please use top-level gtk-doc";
  gtkglext = throw "gnome2.gtkglext has been removed, please use top-level gtkglext";
  startup_notification = throw "gnome2.startup_notification has been removed, please use top-level libstartup_notification";
  startupnotification = throw "gnome2.startupnotification has been removed, please use top-level libstartup_notification";
  gnomedocutils = throw "gnome2.gnomedocutils has been removed, please use top-level gnome-doc-utils";
  gnome-icon-theme = throw "gnome2.gnome-icon-theme has been removed, please use top-level gnome-icon-theme";
  gnome_icon_theme = throw "gnome2.gnome_icon_theme has been removed, please use top-level gnome-icon-theme";
  gnomeicontheme = throw "gnome2.gnomeicontheme has been removed, please use top-level gnome-icon-theme";
  gnome_common = throw "gnome2.gnome_common has been removed, please use top-level gnome-common";

  GConf = throw "gnome2.GConf has been removed as it was long deprecated upstream. Consider using gsettings and dconf instead."; # 2026-07-23
  gnome-common = throw "gnome2.gnome-common has been removed as it was deprecated upstream and unused in Nixpkgs"; # Added 2026-07-23
  gnome_mime_data = throw "gnome2.gnome_mime_data has been removed as it was unused in Nixpkgs"; # 2026-07-23
  gnome_python = throw "gnome2.gnome_python has been removed"; # 2023-01-14
  gnome_python_desktop = throw "gnome2.gnome_python_desktop has been removed"; # 2023-01-14
  gnome_vfs = throw "gnome2.gnome_vfs has been removed"; # 2024-06-27
  gtkhtml = throw "gnome2.gtkhtml has been removed"; # 2023-01-15
  gtkhtml4 = throw "gnome2.gtkhtml4 has been removed"; # 2023-01-15
  libart_lgpl = throw "gnome2.libart_lpl has been removed as it was deprecated upstream and unused in Nixpkgs"; # 2026-07-23
  libbonobo = throw "gnome2.libbonobo has been removed"; # 2024-06-27
  libbonoboui = throw "gnome2.libbonoboui has been removed"; # 2024-06-27
  libglade = throw "gnome2.libglade has been removed as it has been archived upstream since January 2010"; # 2026-07-23
  libglademm = throw "gnome2.libglademm has been removed"; # 2022-01-15
  libgnomecanvas = throw "gnome2.libgnomecanvas has been removed as it has been archived upstream since April 2012"; # 2026-07-23
  libgnomecanvasmm = throw "gnome2.libgnomecanvasmm has been removed"; # 2022-01-15
  libgnomecups = throw "gnome2.libgnomecups has been removed"; # 2023-01-15
  libgnomeprint = throw "gnome2.libgnomeprint has been removed"; # 2023-01-15
  libgnomeprintui = throw "gnome2.libgnomeprintui has been removed"; # 2023-01-15
  libgnome = throw "gnome2.libgnome has been removed"; # 2024-06-27
  libgnomeui = throw "gnome2.libgnomeui has been removed"; # 2024-06-27
  libgtkhtml = throw "gnome2.libgtkhtml has been removed"; # 2023-01-15
  libgtksourceview = throw "gnome2.libgtksourceview has been removed as it was unmaintained upstream and depended on the deprecated GTK2 engine. Consider using gtksourceview3, gtksourceview4, or gtksourceview5 instead."; # 2026-07-23
  libIDL = throw "gnome2.libIDL has been removed as it has been archived upstream since July 2014"; # 2026-07-23
  ORBit2 = throw "gnome2.ORBit2 has been removed as it has been archived upstream since July 2016"; # 2026-07-23
  python_rsvg = throw "gnome2.python_rsvg has been removed"; # 2023-01-14
}
