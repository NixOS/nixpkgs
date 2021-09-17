{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  pname = "libnetfilter_cthelper";
  version = "1.0.0";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_cthelper/files/${pname}-${version}.tar.bz2";
    sha256 = "07618e71c4d9a6b6b3dc1986540486ee310a9838ba754926c7d14a17d8fccf3d";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = {
    description = "Userspace library that provides the programming interface to the user-space connection tracking helper infrastructure";
    longDescription = ''
      libnetfilter_cthelper is the userspace library that provides the programming interface
      to the user-space helper infrastructure available since Linux kernel 3.6. With this
      library, you register, configure, enable and disable user-space helpers. This library
      is used by conntrack-tools.
    '';
    homepage = "https://www.netfilter.org/projects/libnetfilter_cthelper/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
