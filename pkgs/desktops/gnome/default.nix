args: with args;

#assert dbus_glib.glib == gtkLibs.glib;

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
      glib pango bison flex gettext intltool
    ];

    propagatedBuildInputs = [libxml2 libart_lgpl];
  };

  libgnomeprintui = stdenv.mkDerivation {
    inherit (desktop.libgnomeprintui) name src;

    buildInputs = [
      perl perlXMLParser pkgconfig gtk libgnomecanvas gnomeicontheme
      gettext intltool
    ];

    propagatedBuildInputs = [
      libgnomeprint
    ];
  };

  gtkhtml = import ./gtkhtml.nix {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libjpeg gettext intltool enchant isocodes;
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
            GConf /* idem */ libgnomeprintui libgnomecanvas /* !!! through printui */ 
	    intltool;
    input = desktop.gtksourceview;
  };

  gtksourceview_24 = stdenv.mkDerivation {
    name = "gtksourceview-2.4.2";

    src = fetchurl {
      url = http://ftp.gnome.org/pub/gnome/sources/gtksourceview/2.4/gtksourceview-2.4.2.tar.bz2;
      sha256 = "1grc2y817c0xd225l0m92ja35x2bgld5npa4w3g21amkqhdnpka9";
    };
    
    buildInputs = [
      perl perlXMLParser pkgconfig gnomevfs libbonobo GConf
      libgnomeprintui libgnomecanvas gettext intltool
    ];
    propagatedBuildInputs = [gtk libxml2 libgnomeprint];
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

  gnomedesktop = stdenv.mkDerivation {
    inherit (desktop.gnomedesktop) name src;

    # !!! should get rid of libxml2Python, see gnomedocutils
  
    buildInputs = [
      pkgconfig perl perlXMLParser gtk glib libgnomeui
      scrollkeeper libjpeg gnomedocutils gettext which
      python libxml2Python libxslt intltool
    ];

    configureFlags = "--disable-scrollkeeper";
  };

  libwnck = stdenv.mkDerivation {
    inherit (desktop.libwnck) name src;
    buildInputs = [pkgconfig gtk perl perlXMLParser gettext intltool];
  };

  gnomemenus = stdenv.mkDerivation {
    inherit (desktop.gnomemenus) name src;
    buildInputs = [
      pkgconfig perl perlXMLParser glib python gettext intltool
    ];
  };

  librsvg = stdenv.mkDerivation {
    inherit (desktop.librsvg) name src;
    buildInputs = [libxml2 libart_lgpl pkgconfig glib pkgconfig pango gtk];
  };

  libgweather = stdenv.mkDerivation {
    inherit (desktop.libgweather) name src;
    configureFlags = "--with-zoneinfo-dir=/etc/localtime"; # is created by nixos. This is the default location of debian/ gentoo as well
    buildInputs = [
      gettext perl perlXMLParser pkgconfig gtk libxml2 gnomevfs
      intltool libsoup
    ];
  };

  gnomepanel = stdenv.mkDerivation {
    inherit (desktop.gnomepanel) name src;

    buildInputs = [
      pkgconfig perl perlXMLParser gtk glib ORBit2 libgnome libgnomeui
      gnomedesktop libglade libwnck libjpeg libpng scrollkeeper
      xlibs.libXmu xlibs.libXau dbus_glib gnomemenus gnomedocutils
      gettext libxslt librsvg libgweather which intltool
    ];

    configureFlags = "--disable-scrollkeeper";
  };

  libsoup = import ./libsoup.nix {
    inherit stdenv fetchurl pkgconfig libxml2 glib 
      libproxy GConf sqlite;
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
      GConf startupnotification gettext libcm intltool zenity gnomedocutils;
    inherit (xlibs) libXinerama libXrandr libXcursor
      libXcomposite libXfixes libXdamage;
    enableCompositor = true;
    input = desktop.metacity;
  };

  zenity = stdenv.mkDerivation {
    inherit (desktop.zenity) name src;
  
    buildInputs = [
      pkgconfig glib gtk
      gettext intltool gnomedocutils libglade
      libxslt
      xlibs.libX11
    ];

    preConfigure = ''export NIX_LDFLAGS="$NIX_LDFLAGS -lX11";'';
    configureFlags = "--disable-scrollkeeper";
  };

  gnomedocutils = import ./gnome-doc-utils.nix {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser python
      libxml2 libxslt gettext libxml2Python;
    input = desktop.gnomedocutils;
  };

  gconfeditor = stdenv.mkDerivation {
    inherit (desktop.gconfeditor) name src;
  
    buildInputs = [
      pkgconfig perl perlXMLParser GConf gnomedocutils
      gtk libgnome libgnomeui gettext libxslt intltool
      polkit dbus_glib
    ];

    configureFlags = "--disable-scrollkeeper";
  };

  vte = stdenv.mkDerivation {
    inherit (desktop.vte) name src;
  
    buildInputs = [
      pkgconfig perl perlXMLParser glib gtk python gettext intltool
    ];
  
    propagatedBuildInputs = [ncurses];
  };
  
  gnometerminal = stdenv.mkDerivation {
    inherit (desktop.gnometerminal) name src;

    buildInputs = [
      pkgconfig perl perlXMLParser gtk GConf libglade libgnomeui
      startupnotification gnomevfs vte gnomedocutils gettext which
      scrollkeeper python libxml2Python libxslt intltool
      dbus_glib
    ];

    configureFlags = "--disable-scrollkeeper";
  };

  libgtop = stdenv.mkDerivation {
    inherit (desktop.libgtop) name src;
  
    buildInputs = [
      pkgconfig perl perlXMLParser glib popt gettext intltool
    ];
  };
  
  gnomeutils = stdenv.mkDerivation {
    inherit (desktop.gnomeutils) name src;
  
    buildInputs = [
      pkgconfig perl perlXMLParser glib gtk libgnome libgnomeui
      libglade libgnomeprintui gnomedesktop gnomepanel libgtop
      scrollkeeper gnomedocutils gettext libxslt xlibs.libXmu intltool
      which
    ]; 

    configureFlags = "--disable-scrollkeeper";
  };
  
  gtkdoc = import ./gtkdoc.nix {
    inherit (platform) gtkdoc;
    inherit stdenv pkgconfig gnomedocutils perl python libxml2
      xmlto docbook2x docbook_xsl docbook_xml_dtd_43 libxslt
      scrollkeeper;
  };
  
};

in gnome

