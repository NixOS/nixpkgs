{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.4.3";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "0w9bmasln4z8mn16s1is55a06w3nv8jbyal496z5jvr5vcxkm112";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # libassuan-config

  buildInputs = [ libgpgerror pth ];

  doCheck = true;

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' $dev/include/assuan.h
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
