{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.2.1";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "1pp2kl5gc2vja41g3wk03h1hgh7gxy6pj354fb5n4lrlg6xqb4ll";
  };

  buildInputs = [ libgpgerror pth ];

  doCheck = true;

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror}/include/gpg-error.h",g' $out/include/assuan.h
  '';

  meta = {
    description = "IPC library used by GnuPG and related software";

    longDescription = ''
      Libassuan is a small library implementing the so-called Assuan
      protocol.  This protocol is used for IPC between most newer
      GnuPG components.  Both, server and client side functions are
      provided.
    '';

    homepage = http://gnupg.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
