{ stdenv, fetchurl, pkgconfig, python, utillinux, glib
, cryptsetup, nss, nspr, gnupg1orig, gpgme, gettext
# Test requirements:
, nssTools
}:

stdenv.mkDerivation rec {
  name = "volume_key-${version}";
  version = "0.3.9";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/v/o/volume_key/${name}.tar.xz";
    sha256 = "19hj0j8vdd0plp1wvw0yrb4i6j9y3lvp27hchp3cwspmkgz582j5";
  };

  postPatch = let
    pkg = "python${stdenv.lib.optionalString (python.isPy3 or false) "3"}";
  in ''
    sed -i \
      -e 's!/usr/include/python!${python}/include/python!' \
      -e 's!-lpython[^ ]*!`pkg-config --ldflags ${pkg}`!' \
      Makefile.*
    sed -i -e '/^#include <config\.h>$/d' lib/libvolume_key.h
  '';

  buildInputs = [
    pkgconfig python utillinux glib cryptsetup nss nspr gettext
    # GnuPG 2 cannot receive passphrases from GPGME.
    gnupg1orig (gpgme.override { useGnupg1 = true; })
    # Test requirements:
    nssTools
  ];

  doCheck = true;
  preCheck = "export HOME=\"$(mktemp -d)\"";

  meta = {
    homepage = "https://fedorahosted.org/volume_key/";
    description = "Library for manipulating storage volume encryption keys";
    license = stdenv.lib.licenses.gpl2;
  };
}
