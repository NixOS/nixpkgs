{ stdenv, fetchurl, pkgconfig, audiofile, gtkLibs
, flex, bison, popt, perl, zlib, libxml2, bzip2
}:

rec {

  glib = gtkLibs.glib;
  gtk = gtkLibs.gtk;

  esound = (import ./esound) {
    inherit fetchurl stdenv audiofile;
  };

  libIDL = (import ./libIDL) {
    inherit fetchurl stdenv pkgconfig glib;
    lex = flex;
    yacc = bison;
  };

  ORBit2 = (import ./ORBit2) {
    inherit fetchurl stdenv pkgconfig glib libIDL popt;
  };

  GConf = (import ./GConf) {
    inherit fetchurl stdenv pkgconfig perl glib gtk libxml2 ORBit2 popt;
  };

  libbonobo = (import ./libbonobo) {
    inherit fetchurl stdenv pkgconfig perl ORBit2 libxml2 popt flex;
    yacc = bison;
  };

  gnomemimedata = (import ./gnome-mime-data) {
    inherit fetchurl stdenv pkgconfig perl;
  };

  gnomevfs = (import ./gnome-vfs) {
    inherit fetchurl stdenv pkgconfig perl glib libxml2 GConf
            libbonobo gnomemimedata popt bzip2;
    # !!! use stdenv.bzip2
  };

  libgnome = (import ./libgnome) {
    inherit fetchurl stdenv pkgconfig perl glib gnomevfs
            libbonobo GConf popt zlib;
  };

  libart_lgpl = (import ./libart_lgpl) {
    inherit fetchurl stdenv;
  };

  libglade = (import ./libglade) {
    inherit fetchurl stdenv pkgconfig gtk libxml2;
  };

  libgnomecanvas = (import ./libgnomecanvas) {
    inherit fetchurl stdenv pkgconfig gtk libglade;
    libart = libart_lgpl;
  };

  libbonoboui = (import ./libbonoboui) {
    inherit fetchurl stdenv pkgconfig perl libxml2 libglade
            libgnome libgnomecanvas;
  };

  libgnomeui = (import ./libgnomeui) {
    inherit fetchurl stdenv pkgconfig libgnome libgnomecanvas
            libbonoboui libglade;
  };

}