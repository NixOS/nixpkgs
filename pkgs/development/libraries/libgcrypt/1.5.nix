{ lib, stdenv, fetchpatch, fetchurl, libgpg-error, enableCapabilities ? false, libcap }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "libgcrypt";
  version = "1.5.6";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/libgcrypt-${version}.tar.bz2";
    sha256 = "0ydy7bgra5jbq9mxl5x031nif3m6y3balc6ndw2ngj11wnsjc61h";
  };

  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "fix-x86_64-apple-darwin.patch";
      sha256 = "138sfwl1avpy19320dbd63mskspc1khlc93j1f1zmylxx3w19csi";
      url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=patch;h=71939faa7c54e7b4b28d115e748a85f134876a02";
    })
  ];

  buildInputs =
    [ libgpg-error ]
    ++ lib.optional enableCapabilities libcap;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpg-error.dev}/include/gpg-error.h",g' $out/include/gcrypt.h
  '' + lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    description = "General-pupose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    knownVulnerabilities = [
      "CVE-2014-3591"
      "CVE-2015-0837"
      "CVE-2015-7511"
      "CVE-2017-0379"
      "CVE-2017-7526"
      "CVE-2017-9526"
      "CVE-2018-0495"
      "CVE-2018-6829"
      "CVE-2018-12437"
    ];
  };
}
