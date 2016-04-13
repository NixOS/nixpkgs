{ lib, stdenv, fetchurl, libgpgerror, enableCapabilities ? false, libcap }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgcrypt-1.6.5";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0959mwfzsxhallxdqlw359xg180ll2skxwyy35qawmfl89cbr7pl";
  };

  outputs = [ "dev" "out" "info" ];
  outputBin = "dev";

  buildInputs =
    [ libgpgerror ]
    ++ lib.optional enableCapabilities libcap;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  '' + stdenv.lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.out}/lib \1,' $out/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    cp src/.libs/libgcrypt.20.dylib $out/lib
  '';

  doCheck = true;

  meta = {
    homepage = https://www.gnu.org/software/libgcrypt/;
    description = "General-pupose cryptographic library";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.wkennington ];
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
