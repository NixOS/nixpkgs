# todo audiofile is also part of the gnome platform. Move it to this collection?

args: with args;

assert dbus_glib.glib == gtkLibs.glib;

let gnome = 

rec {

  # Platform

  platform = import ./src-gnome-platform-2.16.3.nix {
    inherit fetchurl;
  };

  glib = gtkLibs.glib;

  atk = gtkLibs.atk;

  pango = gtkLibs.pango;

  gtk = gtkLibs.gtk;

  esound = import ./esound.nix {
    inherit fetchurl stdenv audiofile;
    input = platform.esound;
  };

  libIDL = import ./libIDL.nix {
    inherit fetchurl stdenv pkgconfig glib;
    input = platform.libIDL;
    lex = flex;
    yacc = bison;
  };

  ORBit2 = import ./ORBit2.nix {
    inherit fetchurl stdenv pkgconfig glib libIDL popt;
    input = platform.ORBit2;
  };

  GConf = import ./GConf.nix {
    inherit fetchurl stdenv pkgconfig perl glib gtk libxml2 ORBit2 popt;
    input = platform.GConf;
  };

  gnomemimedata = import ./gnome-mime-data.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser gettext;
    input = platform.gnomemimedata;
  };

  gnomevfs = import ./gnome-vfs.nix {
    inherit fetchurl stdenv gnome pkgconfig perl libxml2 popt
      perlXMLParser gettext bzip2 dbus_glib openssl hal samba fam;
    input = platform.gnomevfs;
  };

  gail = import ./gail.nix {
    inherit fetchurl stdenv pkgconfig;
    inherit gtk atk libgnomecanvas;
    input = platform.gail;
  };

  libgnome = import ./libgnome.nix {
    inherit fetchurl stdenv gnome pkgconfig perl perlXMLParser
      popt zlib esound gettext;
    input = platform.libgnome;
  };

  libart_lgpl = import ./libart_lgpl.nix {
    inherit fetchurl stdenv;
    input = platform.libart_lgpl;
  };

  libglade = import ./libglade.nix {
    inherit fetchurl stdenv pkgconfig gtk libxml2;
    input = platform.libglade;
  };

  libgnomecanvas = import ./libgnomecanvas.nix {
    inherit fetchurl stdenv pkgconfig gtk libglade;
    libart = libart_lgpl;
    input = platform.libgnomecanvas;
  };

  libbonobo = import ./libbonobo.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser ORBit2 libxml2 popt flex gettext;
    yacc = bison;
    input = platform.libbonobo;
  };

  libbonoboui = import ./libbonoboui.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 libglade
            libgnome libgnomecanvas gettext;
    input = platform.libbonoboui;
  };

  libgnomeui = import ./libgnomeui.nix {
    inherit fetchurl stdenv gnome pkgconfig perl perlXMLParser
      libjpeg esound gettext;
    input = platform.libgnomeui;
  };

  intltool = import ./intltool.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = platform.intltool;
  };


  # Desktop

  desktop = import ./src-gnome-desktop-2.16.3.nix {
    inherit fetchurl;
  };

  libgnomeprint = import ./libgnomeprint.nix {
    inherit fetchurl stdenv libxml2 perl perlXMLParser pkgconfig popt
         bison flex;
    inherit glib pango;
    libart = libart_lgpl;
    input = desktop.libgnomeprint;
  };

  libgnomeprintui = import ./libgnomeprintui.nix {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig;
    inherit gtk libgnomeprint libgnomecanvas gnomeicontheme;
    input = desktop.libgnomeprintui;
  };

  gtkhtml = import ./gtkhtml.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libjpeg gettext;
    inherit gtk atk gail libgnomeprint libgnomeprintui libgnomeui libglade gnomeicontheme;
    input = desktop.gtkhtml;
  };

  libgtkhtml = gtkhtml;

  gnomeicontheme = import ./gnome-icon-theme.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser
      iconnamingutils gettext;
    input = desktop.gnomeicontheme;
  };

  gnomekeyring = import ./gnome-keyring.nix {
    inherit fetchurl stdenv pkgconfig glib gtk perl perlXMLParser gettext;
    input = desktop.gnomekeyring;
  };

  gtksourceview = import ./gtksourceview.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser gtk libxml2 gettext
            libgnomeprint gnomevfs libbonobo /* !!! <- should be propagated in gnomevfs */
            GConf /* idem */ libgnomeprintui libgnomecanvas /* !!! through printui */;
    input = desktop.gtksourceview;
  };

  scrollkeeper = import ./scrollkeeper.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser
            libxml2 libxslt docbook_xml_dtd_42;
    input = desktop.scrollkeeper;
  };

  gnomedesktop = import ./gnome-desktop.nix {
    inherit fetchurl stdenv pkgconfig gnome perl perlXMLParser
      libjpeg gettext which python libxml2Python libxslt;
    input = desktop.gnomedesktop;
  };

  libwnck = import ./libwnck.nix {
    inherit fetchurl stdenv pkgconfig gtk perl perlXMLParser gettext;
    input = desktop.libwnck;
  };

  gnomemenus = import ./gnome-menus.nix {
    inherit fetchurl stdenv pkgconfig gnome perl perlXMLParser
      python gettext;
    input = desktop.gnomemenus;
  };

  gnomepanel = import ./gnome-panel.nix {
    inherit fetchurl stdenv pkgconfig gnome perl perlXMLParser libjpeg
      libpng dbus_glib gettext libxslt;
    inherit (xlibs) libXmu libXau;
    input = desktop.gnomepanel;
  };

  libsoup = import ./libsoup.nix {
    inherit stdenv fetchurl pkgconfig libxml2 glib;
    input = desktop.libsoup;
  };
  
  startupnotification = import ./startup-notification.nix {
    inherit stdenv fetchurl pkgconfig x11;
    input = desktop.startupnotification;
  };

  metacity = import ./metacity.nix {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser glib gtk
      GConf startupnotification gettext libcm;
    inherit (xlibs) libXinerama libXrandr libXcursor
      libXcomposite libXfixes libXdamage;
    enableCompositor = true;
    input = desktop.metacity;
  };

  gnomedocutils = import ./gnome-doc-utils.nix {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser python
      libxml2 libxslt gettext libxml2Python;
    input = desktop.gnomedocutils;
  };

  gconfeditor = import ./gconf-editor.nix {
    inherit stdenv fetchurl pkgconfig gnome perl perlXMLParser
      gettext libxslt;
    input = desktop.gconfeditor;
  };

  vte = import ./vte.nix {
    inherit stdenv fetchurl pkgconfig gnome perl perlXMLParser ncurses
      python gettext;
    input = desktop.vte;
  };
  
  gnometerminal = import ./gnome-terminal.nix {
    inherit stdenv fetchurl pkgconfig gnome perl perlXMLParser
      gettext which python libxml2Python libxslt;
    input = desktop.gnometerminal;
  };

  libgtop = import ./libgtop.nix {
    inherit stdenv fetchurl pkgconfig gnome perl perlXMLParser
      popt gettext;
    input = desktop.libgtop;
  };
  
  gnomeutils = import ./gnome-utils.nix {
    inherit stdenv fetchurl pkgconfig gnome perl perlXMLParser
      gettext libxslt /*  which python libxml2Python libxslt */;
    inherit (xlibs) libXmu;
    input = desktop.gnomeutils;
  };
  
};

in gnome

