{ stdenv, fetchurl }:

let

in
stdenv.mkDerivation rec {
  name = "libnet-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/libnet-dev/${name}.tar.gz";
    sha256 = "0yj6xjk1wwfhqsfjf32hw5jcjvf86f22d84kzirbddn44mcbp4nk";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sam-github/libnet;
    description = "Portable framework for low-level network packet construction";
    license = [ licenses.bsd2 licenses.bsd3 ];
    platforms = platforms.unix;
  };
}
