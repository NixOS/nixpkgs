{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmnl-1.0.4";

  src = fetchurl {
    url = "http://netfilter.org/projects/libmnl/files/${name}.tar.bz2";
    sha256 = "108zampspaalv44zn0ar9h386dlfixpd149bnxa5hsi8kxlqj7qp";
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
    homepage = https://netfilter.org/projects/libmnl/index.html;
    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = stdenv.lib.platforms.linux;
  };
}
