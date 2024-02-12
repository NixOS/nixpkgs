{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  pname = "libnetfilter_cttimeout";
  version = "1.0.1";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_cttimeout/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-C1naLzIE4cgMuF0fbXIoX8B7AaL1Z4q/Xcz7vv1lAyU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = {
    description = "Userspace library that provides the programming interface to the connection tracking timeout infrastructure";
    longDescription = ''
      libnetfilter_cttimeout is the userspace library that provides the programming
      interface to the fine-grain connection tracking timeout infrastructure.
      With this library, you can create, update and delete timeout policies that can
      be attached to traffic flows. This library is used by conntrack-tools.
    '';
    homepage = "https://netfilter.org/projects/libnetfilter_cttimeout/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
