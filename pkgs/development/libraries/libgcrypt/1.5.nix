{ lib, stdenv, fetchurl, libgpgerror, enableCapabilities ? false, libcap }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgcrypt-1.5.6";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0ydy7bgra5jbq9mxl5x031nif3m6y3balc6ndw2ngj11wnsjc61h";
  };

  buildInputs =
    [ libgpgerror ]
    ++ lib.optional enableCapabilities libcap;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' $out/include/gcrypt.h
  '' + stdenv.lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libgcrypt/;
    description = "General-pupose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
