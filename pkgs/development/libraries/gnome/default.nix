# todo audiofile is also part of the gnome platform. Move it to this collection?

{ stdenv, fetchurl, pkgconfig, audiofile
, flex, bison, popt, perl, zlib, libxml2, libxslt
, perlXMLParser, docbook_xml_dtd_42, gettext, x11, libtiff, libjpeg
, libpng, gtkLibs, libXmu, bzip2
}:

rec {

  # Platform

  platform = (import ./src-gnome-platform-2.14.3.nix) {
    inherit fetchurl;
  };

  glib = gtkLibs.glib;

  atk = gtkLibs.atk;

  pango = gtkLibs.pango;

  gtk = gtkLibs.gtk;

  esound = (import ./esound) {
    inherit fetchurl stdenv audiofile;
    input = platform.esound;
  };

  libIDL = (import ./libIDL) {
    inherit fetchurl stdenv pkgconfig glib;
    input = platform.libIDL;
    lex = flex;
    yacc = bison;
  };

  ORBit2 = (import ./ORBit2) {
    inherit fetchurl stdenv pkgconfig glib libIDL popt;
    input = platform.ORBit2;
  };

  GConf = (import ./GConf) {
    inherit fetchurl stdenv pkgconfig perl glib gtk libxml2 ORBit2 popt;
    input = platform.GConf;
  };

  gnomemimedata = (import ./gnome-mime-data) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = platform.gnomemimedata;
  };

  gnomevfs = (import ./gnome-vfs) {
    inherit fetchurl stdenv pkgconfig perl glib libxml2 GConf
            libbonobo gnomemimedata popt perlXMLParser gettext bzip2;
    input = platform.gnomevfs;
  };

  gail = (import ./gail) {
    inherit fetchurl stdenv pkgconfig;
    inherit gtk atk libgnomecanvas;
    input = platform.gail;
  };

  libgnome = (import ./libgnome) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser glib gnomevfs
            libbonobo GConf popt zlib esound;
    input = platform.libgnome;
  };

  libart_lgpl = (import ./libart_lgpl) {
    inherit fetchurl stdenv;
    input = platform.libart_lgpl;
  };

  libglade = (import ./libglade) {
    inherit fetchurl stdenv pkgconfig gtk libxml2;
    input = platform.libglade;
  };

  libgnomecanvas = (import ./libgnomecanvas) {
    inherit fetchurl stdenv pkgconfig gtk libglade;
    libart = libart_lgpl;
    input = platform.libgnomecanvas;
  };

  libbonobo = (import ./libbonobo) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser ORBit2 libxml2 popt flex;
    yacc = bison;
    input = platform.libbonobo;
  };

  libbonoboui = (import ./libbonoboui) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 libglade
            libgnome libgnomecanvas gettext;
    input = platform.libbonoboui;
  };

  libgnomeui = (import ./libgnomeui) {
    inherit fetchurl stdenv pkgconfig libgnome libgnomecanvas
            libbonoboui libglade libjpeg esound gnomekeyring;
    input = platform.libgnomeui;
  };

  intltool = (import ./intltool) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = platform.intltool;
  };


  # Desktop

  desktop = (import ./src-gnome-desktop-2.14.3.nix) {
    inherit fetchurl;
  };

  libgnomeprint = (import ./libgnomeprint) {
    inherit fetchurl stdenv libxml2 perl perlXMLParser pkgconfig popt
         bison flex;
    inherit glib pango;
    libart = libart_lgpl;
    input = desktop.libgnomeprint;
  };

  libgnomeprintui = (import ./libgnomeprintui) {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig;
    inherit gtk libgnomeprint libgnomecanvas gnomeicontheme;
    input = desktop.libgnomeprintui;
  };

  gtkhtml = (import ./gtkhtml) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libjpeg gettext;
    inherit gtk atk gail libgnomeprint libgnomeprintui libgnomeui libglade gnomeicontheme;
    input = desktop.gtkhtml;
  };

  libgtkhtml = gtkhtml;

  gnomeicontheme = (import ./gnome-icon-theme) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = desktop.gnomeicontheme;
  };

  gnomekeyring = (import ./gnome-keyring) {
    inherit fetchurl stdenv pkgconfig glib gtk;
    input = desktop.gnomekeyring;
  };

  gtksourceview = (import ./gtksourceview) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser gtk libxml2
            libgnomeprint gnomevfs libbonobo /* !!! <- should be propagated in gnomevfs */
            GConf /* idem */ libgnomeprintui libgnomecanvas /* !!! through printui */;
    input = desktop.gtksourceview;
  };

  scrollkeeper = (import ./scrollkeeper) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser
            libxml2 libxslt docbook_xml_dtd_42;
    input = desktop.scrollkeeper;
  };

  gnomedesktop = (import ./gnome-desktop) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser glib gtk
            libgnomeui scrollkeeper libjpeg;
    input = desktop.gnomedesktop;
  };

  libwnck = (import ./libwnck) {
    inherit fetchurl stdenv pkgconfig gtk;
    input = desktop.libwnck;
  };

  gnomepanel = (import ./gnome-panel) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser glib gtk ORBit2
            libgnome libgnomeui gnomedesktop libglade libwnck
            libjpeg libpng scrollkeeper libXmu;
    input = desktop.gnomepanel;
  };

  libsoup = (import ./libsoup) {
    inherit stdenv fetchurl pkgconfig libxml2 glib;
    input = desktop.libsoup;
  };
  
}
