{ stdenv, fetchurl, alsaLib, bash, help2man, pkgconfig, x11, python3 }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.2a";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "011nwpxm5d12rsapljg3pjf9pgb0j8ngmc3zg69q4kv61hkx2zim";
  };

  patchPhase = ''
    sed -e 's|^#!/usr/bin/env python3$|#!${python3}/bin/python3|g' -i tools/*.py
  '';

  preBuild = "patchShebangs .";

  buildInputs = [ alsaLib help2man pkgconfig x11 python3 ];

  configureFlags = [
    "--with-driver=devinput"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-sandboxed"
  ];

  makeFlags = [ "m4dir=$(out)/m4" ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = http://www.lirc.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
