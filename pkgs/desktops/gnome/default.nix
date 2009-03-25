args: with args;

assert dbus_glib.glib == gtkLibs.glib;

let gnome = 

rec {

  # Platform

  platform = import ./src-gnome-platform-2.26.0.nix {
    inherit fetchurl;
  };

  glib = gtkLibs.glib;

  atk = gtkLibs.atk;

  pango = gtkLibs.pango;

  gtk = gtkLibs.gtk;

  audiofile = stdenv.mkDerivation {
    inherit (platform.audiofile) name src;
  };

  esound = stdenv.mkDerivation {
    inherit (platform.esound) name src;
    propagatedBuildInputs = [pkgconfig audiofile];
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

  GConf = stdenv.mkDerivation {
    inherit (platform.GConf) name src;
    buildInputs = [
      pkgconfig perl glib gtk libxml2
      dbus dbus_glib
      popt gettext perlXMLParser intltool
    ];
    propagatedBuildInputs = [ORBit2];
  };

  gnomemimedata = import ./gnome-mime-data.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser gettext;
    input = platform.gnomemimedata;
  };

  gnomevfs = stdenv.mkDerivation {
    inherit (platform.gnomevfs) name src;
    buildInputs = [
      pkgconfig perl glib libxml2 libbonobo
      gnomemimedata popt perlXMLParser gettext intltool bzip2
      dbus_glib hal openssl samba fam
    ];
    propagatedBuildInputs = [GConf];
    patches = [./no-kerberos.patch];
  };

  gail = stdenv.mkDerivation {
    name = "gail-1.22.3";
    src = fetchurl {
      url = "http://ftp.gnome.org/pub/GNOME/sources/gail/1.22/gail-1.22.3.tar.bz2";
      sha256 = "1s4s0ndjh42i8x2mchz0xm3qcp942vkmz0jsq7ig1d3y4wlk1w03";
    };
    buildInputs = [pkgconfig atk gtk];
  };

  libgnome = import ./libgnome.nix {
    inherit fetchurl stdenv gnome pkgconfig perl perlXMLParser
      popt zlib esound gettext intltool;
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

  libglademm = import ./libglademm.nix {
    inherit fetchurl stdenv pkgconfig libglade;
    inherit (gtkLibs) gtkmm;
  };

  libgnomecanvas = stdenv.mkDerivation {
    inherit (platform.libgnomecanvas) name src;
    buildInputs = [
      pkgconfig libglade perl perlXMLParser gail
      gettext intltool
    ];
    propagatedBuildInputs = [gtk libart_lgpl];
  };

  libbonobo = import ./libbonobo.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser ORBit2
      dbus dbus_glib libxml2 popt flex
      gettext intltool;
    yacc = bison;
    input = platform.libbonobo;
  };

  libbonoboui = import ./libbonoboui.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 libglade
            libgnome libgnomecanvas gettext intltool;
    input = platform.libbonoboui;
  };

  libgnomeui = import ./libgnomeui.nix {
    inherit fetchurl stdenv gnome pkgconfig perl perlXMLParser
      libjpeg esound gettext intltool;
    input = platform.libgnomeui;
  };

  intltool = import ./intltool.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
  };


  # Desktop

  desktop = import ./src-gnome-desktop-2.26.0.nix {
    inherit fetchurl;
  };

  libgnomeprint = stdenv.mkDerivation {
    inherit (desktop.libgnomeprint) name src;

    buildInputs = [
      perl perlXMLParser pkgconfig popt libxml2
      glib pango bison flex gettext
    ];

    propagatedBuildInputs = [libxml2 libart_lgpl];
  };

  libgnomeprintui = stdenv.mkDerivation {
    inherit (desktop.libgnomeprintui) name src;

    buildInputs = [
      perl perlXMLParser pkgconfig gtk libgnomecanvas gnomeicontheme
      gettext
    ];

    propagatedBuildInputs = [
      libgnomeprint
    ];
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
    inherit (args) intltool;
    input = desktop.gnomeicontheme;
  };

  gnomekeyring = stdenv.mkDerivation {
    inherit (desktop.gnomekeyring) name src;
    buildInputs = [
      pkgconfig gtk glib perl perlXMLParser gettext intltool
      GConf libgcrypt libtasn1 dbus dbus_glib python
    ];
    CFLAGS = "-DENABLE_NLS=0";
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
    # Scrollkeeper has disappeared from recent Gnome releases, but
    # it's still being used.
    input = {
      name = "scrollkeeper-0.3.14";
      src = fetchurl {
        url = http://ftp.gnome.org/pub/GNOME/desktop/2.16/2.16.3/sources/scrollkeeper-0.3.14.tar.bz2;
        md5 = "b175e582a6cec3e50a9de73a5bb7455a";
      };
    };
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

  librsvg = stdenv.mkDerivation {
    inherit (desktop.librsvg) name src;
    buildInputs = [libxml2 libart_lgpl pkgconfig glib pkgconfig pango gtk];
  };

  libgweather = stdenv.mkDerivation {
    inherit (desktop.libgweather) name src;
    buildInputs = [gettext perl perlXMLParser pkgconfig gtk libxml2 gnomevfs];
  };

  gnomepanel = stdenv.mkDerivation {
    inherit (desktop.gnomepanel) name src;

    buildInputs = [
      pkgconfig perl perlXMLParser gtk glib ORBit2 libgnome libgnomeui
      gnomedesktop libglade libwnck libjpeg libpng scrollkeeper
      xlibs.libXmu xlibs.libXau dbus_glib gnomemenus gnomedocutils
      gettext libxslt librsvg libgweather which
    ];

    configureFlags = "--disable-scrollkeeper";
  };

  libsoup = import ./libsoup.nix {
    inherit stdenv fetchurl pkgconfig libxml2 glib;
    input = desktop.libsoup;
  };
  
  startupnotification = import ./startup-notification.nix {
    inherit stdenv fetchurl pkgconfig x11;
    # Strangely, startup-notificatio has disappeared from Gnome
    # releases, but it's still used. 
    input = {
      name = "startup-notification-0.8";
      src = fetchurl {
        url = http://ftp.gnome.org/pub/GNOME/desktop/2.16/2.16.3/sources/startup-notification-0.8.tar.bz2;
        md5 = "d9b2e9fba18843314ae42334ceb4336d";
      };
    };
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
  
  gnometerminal = stdenv.mkDerivation {
    inherit (desktop.gnometerminal) name src;

    buildInputs = [
      pkgconfig perl perlXMLParser gtk GConf libglade
      libgnomeui startupnotification gnomevfs vte
      gnomedocutils gettext which scrollkeeper
      python libxml2Python libxslt
    ];

    configureFlags = "--disable-scrollkeeper";
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

  gtkdoc = import ./gtkdoc.nix {
    inherit (platform) gtkdoc;
    inherit stdenv args;
  };
  
};

in gnome

