{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmnl";
  version = "1.0.5";

  src = fetchurl {
    url = "https://netfilter.org/projects/libmnl/files/${pname}-${version}.tar.bz2";
    sha256 = "09851ns07399rbz0y8slrlmnw3fn1nakr8d37pxjn5gkks8rnjr7";
  };

  meta = {
    description = "Minimalistic user-space library oriented to Netlink developers";
    longDescription = ''
      libmnl is a minimalistic user-space library oriented to Netlink developers.
      There are a lot of common tasks in parsing, validating, constructing of both the Netlink
      header and TLVs that are repetitive and easy to get wrong.
      This library aims to provide simple helpers that allows you to re-use code and to avoid
      re-inventing the wheel.
    '';
    homepage = "https://netfilter.org/projects/libmnl/index.html";
    license = lib.licenses.lgpl21Plus;

    platforms = lib.platforms.linux;
  };
}
