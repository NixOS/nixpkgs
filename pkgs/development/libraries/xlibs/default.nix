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
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt libXext;
  };

  libXpm = (import ./libXpm) {
    inherit fetchurl stdenv pkgconfig xproto libX11;
  };

  libXaw = (import ./libXaw) {
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt libXmu libXpm;
  };

  libXv = (import ./libXv) {
    inherit fetchurl stdenv pkgconfig libX11 libXext;
  };

  libXi = (import ./libXi) { # Xi = Xinput (not to be confused with Xinerama)
    inherit fetchurl stdenv pkgconfig libX11;
  };

  panoramixext = (import ./panoramixext) {
    inherit fetchurl stdenv;
  };

  libXinerama = (import ./libXinerama) {
    inherit fetchurl stdenv pkgconfig libX11 libXext panoramixext;
  };

  libXp = (import ./libXp) {
    inherit fetchurl stdenv pkgconfig libX11 libXext libXt;
  };

  xf86vmext = import ./xf86vmext {
    inherit fetchurl stdenv;
  };

  libXxf86vm = import ./libXxf86vm {
    inherit fetchurl stdenv pkgconfig libX11 libXext xf86vmext;
  };

  xlibs = (import ./xlibs) {
    inherit stdenv libX11 libXt freetype fontconfig libXft libXext;
  };

  recordext = (import ./recordext) {
    inherit fetchurl stdenv;
  };

  libXtst = (import ./libXtst) {
    inherit fetchurl stdenv pkgconfig libX11 libXext recordext libXtrans;
  };
}
