{stdenv, fetchurl, pkgconfig, freetype, expat}:

rec {

  xproto = (import ./xproto) {
    inherit fetchurl stdenv;
  };

  xextensions = (import ./xextensions) {
    inherit fetchurl stdenv;
  };

  libXtrans = (import ./libXtrans) {
    inherit fetchurl stdenv;
  };

  libXau = (import ./libXau) {
    inherit fetchurl stdenv pkgconfig xproto;
  };

  libX11 = (import ./libX11) {
    inherit fetchurl stdenv pkgconfig xproto xextensions libXtrans libXau;
  };

  libXext = (import ./libXext) {
    inherit fetchurl stdenv pkgconfig xproto xextensions libX11;
  };

  libICE = (import ./libICE) {
    inherit fetchurl stdenv pkgconfig libX11;
  };

  libSM = (import ./libSM) {
    inherit fetchurl stdenv pkgconfig libX11 libICE;
  };

  libXt = (import ./libXt) {
    inherit fetchurl stdenv pkgconfig libX11 libSM;
  };

  renderext = (import ./renderext) {
    inherit fetchurl stdenv;
  };

  libXrender = (import ./libXrender) {
    inherit fetchurl stdenv pkgconfig libX11 renderext;
  };

  fontconfig = (import ./fontconfig) {
    inherit fetchurl stdenv freetype expat;
  };

  libXft = (import ./libXft) {
    inherit fetchurl stdenv pkgconfig libX11 libXrender freetype fontconfig;
  };

  libXmu = (import ./libXmu) {
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt;
  };

  libXpm = (import ./libXpm) {
    inherit fetchurl stdenv pkgconfig xproto libX11;
  };

  libXaw = (import ./libXaw) {
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt libXmu libXpm;
  };

  xlibs = (import ./xlibs) {
    inherit stdenv libX11 libXt freetype fontconfig libXft libXext;
  };

}
