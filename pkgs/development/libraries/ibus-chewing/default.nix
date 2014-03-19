{ stdenv, fetchurl, cmake, pkgconfig
, ibus, libchewing, x11, gtk, gob2, gconf, gettext
, libxcb, libpthreadstubs, libXdmcp
, libXtst, libXi, libXfixes }:

let
  pkgname = "ibus-chewing";
  version = "1.4.7";

in stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "http://ibus.googlecode.com/files/${pkgname}-${version}-Source.tar.gz";
    sha1 = "9e2a9792db374be2575f5dd6998755a699d9011d";
  };

  buildInputs = [
    cmake
    pkgconfig
    x11
    gtk
    gob2
    gconf
    gettext
    libxcb
    libpthreadstubs
    libXdmcp
    libXtst
    libXi
    libXfixes
    ibus
    libchewing
  ];

  postBuild = ''make translations'';
  preInstall = ''sed -i -e "s!/etc!$out/etc!g" cmake_install.cmake'';
}
