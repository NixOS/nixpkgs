# todo audiofile is also part of the gnome platform. Move it to this collection?

{ stdenv, fetchurl, pkgconfig, audiofile
, flex, bison, popt, perl, zlib, libxml2, bzip2
, perlXMLParser, gettext, x11, libtiff, libjpeg
, libpng, gtkLibs
}:

rec {

  # Platform

  platform = (import ./src-gnome-platform-2.8.3.nix) {
    inherit stdenv fetchurl;
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

  gconf = (import ./GConf) {
    inherit fetchurl stdenv pkgconfig perl glib gtk libxml2 ORBit2 popt;
    input = platform.gconf;
  };

  gnomemimedata = (import ./gnome-mime-data) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = platform.gnomemimedata;
  };

  gnomevfs = (import ./gnome-vfs) {
    inherit fetchurl stdenv pkgconfig perl glib libxml2 gconf
            libbonobo gnomemimedata popt bzip2 perlXMLParser;
    # !!! use stdenv.bzip2
    input = platform.gnomevfs;
  };

  gail = (import ./gail) {
    inherit fetchurl stdenv pkgconfig;
    inherit gtk atk libgnomecanvas;
    input = platform.gail;
  };

  libgnome = (import ./libgnome) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser glib gnomevfs
            libbonobo gconf popt zlib;
    input = platform.libgnome;
  };

  libgnomeprint = (import ./libgnomeprint) {
    inherit fetchurl stdenv libxml2 perl perlXMLParser pkgconfig popt;
    inherit glib pango;
    libart = libart_lgpl;
    input = platform.libgnomeprint;
  };

  libgnomeprintui = (import ./libgnomeprintui) {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig;
    inherit gtk libgnomeprint libgnomecanvas gnomeicontheme;
    input = platform.libgnomeprintui;
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

  # Desktop

  desktop = (import ./src-gnome-desktop-2.8.3.nix) {
    inherit stdenv fetchurl;
  };

  gtkhtml = (import ./gtkhtml) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libjpeg;
    inherit gtk atk gail libgnomeprint libgnomeprintui libgnomeui libglade gnomeicontheme;
    input = desktop.gtkhtml;
  };

  libgtkhtml = (import ./libgtkhtml) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser gtk libxml2 gail;
    input = desktop.libgtkhtml;
  };

  gnomeicontheme = (import ./gnome-icon-theme) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser;
    input = desktop.gnomeicontheme;
  };

  gnomekeyring = (import ./gnome-keyring) {
    inherit fetchurl stdenv pkgconfig glib gtk;
    input = desktop.gnomekeyring;
  };
}