{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmnl-1.0.3";

  src = fetchurl {
    url = "http://netfilter.org/projects/libmnl/files/${name}.tar.bz2";
    sha1 = "c27e25f67c6422ebf893fc3a844af8085a1c5b63";
  };

  meta = {
    description = "minimalistic user-space library oriented to Netlink developers";
    longDescription = ''
      libmnl is a minimalistic user-space library oriented to Netlink developers.
      There are a lot of common tasks in parsing, validating, constructing of both the Netlink
      header and TLVs that are repetitive and easy to get wrong.
      This library aims to provide simple helpers that allows you to re-use code and to avoid
      re-inventing the wheel.
    '';
    homepage = http://netfilter.org/projects/libmnl/index.html;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.linux;
  };
}
