{ stdenv, fetchurl, fetchpatch, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  name = "pycrypto-2.6.1";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/p/pycrypto/${name}.tar.gz";
    sha256 = "0g0ayql5b9mkjam8hym6zyg6bv77lbh66rv1fyvgqb17kfc1xkpj";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2013-7459.patch";
      url = "https://anonscm.debian.org/cgit/collab-maint/python-crypto.git/plain/debian/patches/CVE-2013-7459.patch?h=debian/2.6.1-7";
      sha256 = "01r7aghnchc1bpxgdv58qyi2085gh34bxini973xhy3ks7fq3ir9";
    })
  ];

  preConfigure = ''
    sed -i 's,/usr/include,/no-such-dir,' configure
    sed -i "s!,'/usr/include/'!!" setup.py
  '';

  buildInputs = stdenv.lib.optional (!python.isPypy or false) gmp; # optional for pypy

  doCheck = !(python.isPypy or stdenv.isDarwin); # error: AF_UNIX path too long

  meta = {
    homepage = "http://www.pycrypto.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
