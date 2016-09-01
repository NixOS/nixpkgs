{ lib, stdenv, fetchurl, libgpgerror, enableCapabilities ? false, libcap }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgcrypt-${version}";
  version = "1.7.3";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0wbh6fq5zi9wg2xcfvfpwh7dv52jihivx1vm4h91c2kx0w8n3b6x";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  buildInputs =
    [ libgpgerror ]
    ++ lib.optional enableCapabilities libcap;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  '' + stdenv.lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    cp src/.libs/libgcrypt.20.dylib $out/lib
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libgcrypt/;
    description = "General-pupose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.wkennington maintainers.vrthra ];
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
