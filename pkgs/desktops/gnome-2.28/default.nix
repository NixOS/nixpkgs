pkgs:

rec {
#### PLATFORM
  audiofile = import ./platform/audiofile {
    inherit (pkgs) stdenv fetchurl;
  };

  esound = import ./platform/esound {
    inherit (pkgs) stdenv fetchurl pkgconfig alsaLib;
    inherit audiofile;
  };
  
  libIDL = import ./platform/libIDL {
    inherit (pkgs) stdenv fetchurl flex bison pkgconfig;
    inherit (pkgs.gtkLibs) glib;
  };
  
  ORBit2 = import ./platform/ORBit2 {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.gtkLibs) glib;
    inherit libIDL;
  };
  
  libart_lgpl = import ./platform/libart_lgpl {
    inherit (pkgs) stdenv fetchurl;
  };
  
  libglade = import ./platform/libglade {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 expat python gettext;
    inherit (pkgs.gtkLibs) gtk;
  };
  
  intltool = import ./platform/intltool {
    inherit (pkgs) stdenv fetchurl pkgconfig perl perlXMLParser gettext;
  };
  
  GConf = import ./platform/GConf {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib libxml2 expat policykit;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit intltool ORBit2;
  };

  libgnomecanvas = import ./platform/libgnomecanvas {
    inherit (pkgs) stdenv fetchurl pkgconfig cairo;
    inherit (pkgs.gtkLibs) glib gtk pango atk;
    inherit intltool libart_lgpl libglade;
  };

  # for git-head builds
  gnome_common = import platform/gnome-common {
    inherit (pkgs) stdenv fetchgit pkgconfig
      autoconf automake libtool;
  };
  
  gnome_mime_data = import ./platform/gnome-mime-data {
    inherit (pkgs) stdenv fetchurl;
    inherit intltool;
  };
  
  gnome_vfs = import ./platform/gnome-vfs {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 bzip2 openssl samba dbus_glib fam hal cdparanoia;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool GConf gnome_mime_data;
  };
  
  gnome_vfs_monikers = import ./platform/gnome-vfs-monikers {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool gnome_vfs libbonobo ORBit2;
  };
  
  libgnome = import ./platform/libgnome {
    inherit (pkgs) stdenv fetchurl pkgconfig popt;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool esound audiofile libbonobo GConf gnome_vfs ORBit2;
  };
  
  libgnomeui = import ./platform/libgnomeui {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 popt cairo;
    inherit (pkgs.xlibs) libX11 libICE;
    inherit (pkgs.gtkLibs) glib gtk atk pango;
    inherit intltool libgnome libgnomecanvas libbonobo libbonoboui GConf;
    inherit gnome_vfs gnome_keyring libglade libart_lgpl ORBit2;
  };
  
  libbonobo = import ./platform/libbonobo {
    inherit (pkgs) stdenv fetchurl flex bison pkgconfig dbus_glib libxml2 popt;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool ORBit2;
  };
  
  libbonoboui = import ./platform/libbonoboui {
    inherit (pkgs) stdenv fetchurl bison pkgconfig popt libxml2 cairo;
    inherit (pkgs.gtkLibs) glib gtk atk pango;
    inherit intltool libbonobo GConf libgnomecanvas libgnome libglade ORBit2 libart_lgpl;
  };
  
  at_spi = import ./platform/at-spi {
    inherit (pkgs) stdenv fetchurl python pkgconfig popt;
    inherit (pkgs.xlibs) libX11 libICE libXtst libXi;
    inherit (pkgs.gtkLibs) atk gtk;
    inherit intltool libbonobo ORBit2;
  };

  gtk_doc = import ./platform/gtk-doc {
    inherit (pkgs) stdenv fetchurl pkgconfig perl python libxml2 libxslt;
    inherit (pkgs) docbook_xml_dtd_43 docbook_xsl;
    inherit gnome_doc_utils;
  };
  
  # Freedesktop library
  startup_notification = import ./platform/startup-notification {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.xlibs) libX11 libxcb libICE xcbutil libSM;
  };
  
  # Required for nautilus
  libunique = import ./platform/libunique {
    inherit (pkgs) stdenv fetchurl pkgconfig gettext;
    inherit (pkgs.gtkLibs) gtk;
  };
  
#### DESKTOP

  gnome_keyring = import ./desktop/gnome-keyring {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus libgcrypt libtasn1 pam hal python;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit intltool GConf;
  };
  
  libsoup = import ./desktop/libsoup {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 gnutls libproxy sqlite curl;
    inherit (pkgs.gtkLibs) glib;
    inherit GConf;
  };

  # fails with a mysterious error on linking
  # symbol not found although it is actually present
  libsoup_git_head = import ./desktop/libsoup/git-head.nix {
    inherit (pkgs) stdenv fetchgit pkgconfig libxml2 gnutls libproxy sqlite curl
      automake autoconf libtool which;
    glib = pkgs.gtkLibs216.glib_2_21;
    inherit GConf gnome_common gtk_doc gnome_keyring;
  };

  libwnck = import ./desktop/libwnck {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.xlibs) libX11;
    inherit (pkgs.gtkLibs) gtk;
    inherit intltool;
  };
  
  # Not part of GNOME desktop, but provides CSS support for librsvg
  libcroco = import ./desktop/libcroco {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2;
    inherit (pkgs.gtkLibs) glib;
  };
  
  librsvg = import ./desktop/librsvg {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 libgsf bzip2;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit libcroco;
  };
  
  libgweather = import ./desktop/libgweather {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2;
    inherit (pkgs.gtkLibs) gtk;
    inherit intltool GConf libsoup;
  };
  
  gvfs = import ./desktop/gvfs {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus samba hal libarchive fuse libgphoto2 cdparanoia libxml2 libtool;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool GConf gnome_keyring libsoup;
  };
  
  libgnomekbd = import ./desktop/libgnomekbd {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib libxklavier;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit intltool GConf libglade;
  };
  
  # Removed from recent GNOME releases, but still required
  scrollkeeper = import ./desktop/scrollkeeper {
    inherit (pkgs) stdenv fetchurl pkgconfig perl perlXMLParser libxml2 libxslt docbook_xml_dtd_42;
  };
  
  gnome_doc_utils = import ./desktop/gnome-doc-utils {
    inherit (pkgs) stdenv fetchurl python pkgconfig libxml2 libxslt;
    inherit intltool scrollkeeper;
  };
  
  zenity = import ./desktop/zenity {
    inherit (pkgs) stdenv fetchurl pkgconfig cairo libxml2 libxslt;
    inherit (pkgs.gtkLibs) glib gtk pango atk;
    inherit gnome_doc_utils intltool libglade;
    inherit (pkgs.xlibs) libX11;
  };
  
  metacity = import ./desktop/metacity {
    inherit (pkgs) stdenv fetchurl pkgconfig;
    inherit (pkgs.gtkLibs) glib gtk;
    inherit (pkgs.xlibs) libXcomposite libXcursor libXdamage;
    inherit intltool GConf startup_notification zenity gnome_doc_utils;
  };

  gnome_menus = import ./desktop/gnome-menus {
    inherit (pkgs) stdenv fetchurl pkgconfig python;
    inherit (pkgs.gtkLibs) glib;
    inherit intltool;
  };
  
  gnome_desktop = import ./desktop/gnome-desktop {
    inherit (pkgs) stdenv fetchurl pkgconfig python libxslt which;
    libxml2 = pkgs.libxml2Python;
    inherit (pkgs.xlibs) libX11;
    inherit (pkgs.gtkLibs) gtk;
    inherit intltool GConf gnome_doc_utils;
  };
    
  gnome_panel = import ./desktop/gnome-panel {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib dbus cairo popt which bzip2 python libxslt;
    libxml2 = pkgs.libxml2Python;
    inherit (pkgs.gtkLibs) glib gtk pango atk;
    inherit (pkgs.xlibs) libXau;
    inherit intltool ORBit2 libglade libgnome libgnomeui libbonobo libbonoboui GConf gnome_menus gnome_desktop;
    inherit libwnck librsvg libgweather gnome_doc_utils libgnomecanvas libart_lgpl;
  };
  
  gnome_session = import ./desktop/gnome-session {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib cairo dbus;
    inherit (pkgs.gtkLibs) gtk pango atk;
    inherit (pkgs.xlibs) libXau libXtst inputproto;
    inherit intltool libglade startup_notification GConf;
  };
  
  gnome_settings_daemon = import ./desktop/gnome-settings-daemon {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib libxklavier;
    inherit (pkgs.gtkLibs) gtk;
    inherit intltool GConf gnome_desktop libglade libgnomekbd;
  };
  
  gnome_control_center = import ./desktop/gnome-control-center {
    inherit (pkgs) stdenv fetchurl pkgconfig dbus_glib libxklavier hal;
    inherit (pkgs) cairo popt which python libxslt shared_mime_info desktop_file_utils;
    inherit (pkgs.gtkLibs) glib gtk pango atk;
    inherit gnome_doc_utils intltool GConf libglade libgnome libgnomeui libgnomekbd;
    inherit librsvg gnome_menus gnome_desktop gnome_panel metacity gnome_settings_daemon;
    inherit libbonobo libbonoboui libgnomecanvas libart_lgpl gnome_vfs ORBit2;
    libxml2 = pkgs.libxml2Python;
  };
  
  nautilus = import ./desktop/nautilus {
    inherit (pkgs) stdenv fetchurl pkgconfig libxml2 dbus_glib libexif shared_mime_info;
    inherit (pkgs.gtkLibs) gtk;
    inherit gnome_desktop libunique intltool GConf;
  };
}
