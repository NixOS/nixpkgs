{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnetfilter_cttimeout-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_cttimeout/files/${name}.tar.bz2";
    sha256 = "aeab12754f557cba3ce2950a2029963d817490df7edb49880008b34d7ff8feba";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  meta = {
    description = "Userspace library that provides the programming interface to the connection tracking timeout infrastructure";
    longDescription = ''
      libnetfilter_cttimeout is the userspace library that provides the programming
      interface to the fine-grain connection tracking timeout infrastructure.
      With this library, you can create, update and delete timeout policies that can
      be attached to traffic flows. This library is used by conntrack-tools.
    '';
    homepage = https://netfilter.org/projects/libnetfilter_cttimeout/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
